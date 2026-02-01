#!/bin/bash
set -euo pipefail

#-------------------------------------------------------------------------------
# Configuration
#-------------------------------------------------------------------------------
NGINX_VERSION="1.27.1"
OPENSSL_VERSION="3.5.0"
PCRE2_VERSION="10.44"
ZLIB_VERSION="1.2.12"

BUILD_DIR="/usr/local/src/nginx-build"
INSTALL_PREFIX="/etc/nginx"
NGINX_USER="nginx"
NGINX_GROUP="nginx"

# CPU count for parallel builds
NPROC=$(nproc)
export CFLAGS="-O3 -march=native -mtune=native -fomit-frame-pointer -pipe -fstack-protector-strong"
export CXXFLAGS="${CFLAGS}"
export LDFLAGS="-Wl,-O1 -Wl,--as-needed -Wl,-z,relro -Wl,-z,now"

#-------------------------------------------------------------------------------
# Color output
#-------------------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info()  { echo -e "${BLUE}[INFO]${NC} $1"; }
log_ok()    { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

preflight_checks() {
    log_info "Running preflight checks..."

    # Root check
    if [[ $EUID -ne 0 ]]; then
        log_error "This script must be run as root"
        exit 1
    fi

    # OS check
    if [[ ! -f /etc/rocky-release ]]; then
        log_warn "Not running on Rocky Linux - proceeding anyway"
    fi

    # Check for required tools
    local required_tools=(gcc g++ make perl wget tar)
    for tool in "${required_tools[@]}"; do
        if ! command -v "$tool" &>/dev/null; then
            log_error "Required tool not found: $tool"
            exit 1
        fi
    done

    log_ok "Preflight checks passed"
}

install_dependencies() {
    log_info "Installing build dependencies..."

    dnf groupinstall -y "Development Tools"
    dnf install -y \
        gcc gcc-c++ make cmake \
        perl perl-IPC-Cmd \
        wget curl \
        gd-devel \
        libxslt-devel \
        libxml2-devel \
        gperftools-devel \
        kernel-headers \
        systemd-devel

    log_ok "Build dependencies installed"
}

create_nginx_user() {
    log_info "Creating nginx user..."

    if ! id -u ${NGINX_USER} &>/dev/null; then
        useradd --system --no-create-home --shell /sbin/nologin ${NGINX_USER}
        log_ok "Created user: ${NGINX_USER}"
    else
        log_info "User ${NGINX_USER} already exists"
    fi
}

prepare_build_dir() {
    log_info "Preparing build directory: ${BUILD_DIR}"

    rm -rf "${BUILD_DIR}"
    mkdir -p "${BUILD_DIR}"
    cd "${BUILD_DIR}"

    log_ok "Build directory ready"
}

download_sources() {
    log_info "Downloading source packages..."

    cd "${BUILD_DIR}"

    # nginx
    log_info "Downloading nginx ${NGINX_VERSION}..."
    wget -q "https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz"
    tar -xzf "nginx-${NGINX_VERSION}.tar.gz"

    # OpenSSL
    log_info "Downloading OpenSSL ${OPENSSL_VERSION}..."
    wget -q "https://github.com/openssl/openssl/releases/download/openssl-${OPENSSL_VERSION}/openssl-${OPENSSL_VERSION}.tar.gz"
    tar -xzf "openssl-${OPENSSL_VERSION}.tar.gz"

    # PCRE2
    log_info "Downloading PCRE2 ${PCRE2_VERSION}..."
    wget -q "https://github.com/PCRE2Project/pcre2/releases/download/pcre2-${PCRE2_VERSION}/pcre2-${PCRE2_VERSION}.tar.gz"
    tar -xzf "pcre2-${PCRE2_VERSION}.tar.gz"

    # zlib
    log_info "Downloading zlib ${ZLIB_VERSION}..."
    wget -q "https://zlib.net/fossils/zlib-${ZLIB_VERSION}.tar.gz"
    tar -xzf "zlib-${ZLIB_VERSION}.tar.gz"

    log_ok "All sources downloaded and extracted"
}

build_zlib() {
    log_info "Building zlib ${ZLIB_VERSION}..."

    cd "${BUILD_DIR}/zlib-${ZLIB_VERSION}"

    ./configure \
        --prefix="${BUILD_DIR}/zlib-build" \
        --static

    make -j${NPROC}
    make install

    log_ok "zlib built successfully"
}

build_pcre2() {
    log_info "Building PCRE2 ${PCRE2_VERSION} with JIT support..."

    cd "${BUILD_DIR}/pcre2-${PCRE2_VERSION}"

    ./configure \
        --prefix="${BUILD_DIR}/pcre2-build" \
        --enable-pcre2-16 \
        --enable-pcre2-32 \
        --enable-jit \
        --enable-pcre2grep-libz \
        --disable-shared \
        --enable-static

    make -j${NPROC}
    make install

    log_ok "PCRE2 built with JIT support"
}

build_openssl() {
    log_info "Building OpenSSL ${OPENSSL_VERSION} with KTLS support..."

    cd "${BUILD_DIR}/openssl-${OPENSSL_VERSION}"

    # OpenSSL configuration for KTLS and performance
    # enable-ktls: Kernel TLS offload (requires kernel 4.13+ with TLS module)
    # enable-ec_nistp_64_gcc_128: Fast ECDSA/ECDH
    # no-weak-ssl-ciphers: Security hardening
    ./Configure linux-x86_64 \
        --prefix="${BUILD_DIR}/openssl-build" \
        --openssldir="${BUILD_DIR}/openssl-build" \
        enable-ktls \
        enable-ec_nistp_64_gcc_128 \
        no-weak-ssl-ciphers \
        no-ssl3 \
        no-idea \
        no-mdc2 \
        no-rc5 \
        threads \
        shared \
        -DOPENSSL_TLS_SECURITY_LEVEL=2 \
        ${CFLAGS}

    make -j${NPROC}
    make install_sw

    # Create symlinks for runtime
    ln -sf "${BUILD_DIR}/openssl-build/lib64" "${BUILD_DIR}/openssl-build/lib" 2>/dev/null || true

    log_ok "OpenSSL built with KTLS support"
}

build_nginx() {
    log_info "Building nginx ${NGINX_VERSION}..."

    cd "${BUILD_DIR}/nginx-${NGINX_VERSION}"

    ./configure \
        --prefix=${INSTALL_PREFIX} \
        --sbin-path=/usr/sbin/nginx \
        --modules-path=/usr/lib64/nginx/modules \
        --conf-path=${INSTALL_PREFIX}/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --pid-path=/var/run/nginx.pid \
        --lock-path=/var/run/nginx.lock \
        --http-client-body-temp-path=/var/cache/nginx/client_temp \
        --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
        --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
        --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
        --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
        --user=${NGINX_USER} \
        --group=${NGINX_GROUP} \
        \
        --with-compat \
        --with-file-aio \
        --with-threads \
        \
        --with-http_ssl_module \
        --with-http_v2_module \
        --with-http_v3_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_random_index_module \
        --with-http_secure_link_module \
        --with-http_stub_status_module \
        --with-http_auth_request_module \
        --with-http_slice_module \
        \
        --with-stream \
        --with-stream_ssl_module \
        --with-stream_ssl_preread_module \
        --with-stream_realip_module \
        \
        --with-google_perftools_module \
        \
        --with-pcre="${BUILD_DIR}/pcre2-${PCRE2_VERSION}" \
        --with-pcre-jit \
        --with-zlib="${BUILD_DIR}/zlib-${ZLIB_VERSION}" \
        --with-openssl="${BUILD_DIR}/openssl-${OPENSSL_VERSION}" \
        --with-openssl-opt="enable-ktls" \
        \
        --with-cc-opt="${CFLAGS} -I${BUILD_DIR}/openssl-build/include" \
        --with-ld-opt="${LDFLAGS} -L${BUILD_DIR}/openssl-build/lib64 -Wl,-rpath,${BUILD_DIR}/openssl-build/lib64"

    make -j${NPROC}
    make install

    log_ok "nginx built successfully"
}

post_install() {
    log_info "Running post-installation setup..."
    mkdir -p /var/cache/nginx/{client_temp,proxy_temp,fastcgi_temp,uwsgi_temp,scgi_temp}
    mkdir -p /var/log/nginx
    mkdir -p ${INSTALL_PREFIX}/conf.d
    mkdir -p ${INSTALL_PREFIX}/ssl
    chown -R ${NGINX_USER}:${NGINX_GROUP} /var/cache/nginx
    chown -R ${NGINX_USER}:${NGINX_GROUP} /var/log/nginx

    cat > /etc/logrotate.d/nginx << 'EOF'
/var/log/nginx/*.log {
    daily
    missingok
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 nginx nginx
    sharedscripts
    postrotate
        [ -f /var/run/nginx.pid ] && kill -USR1 $(cat /var/run/nginx.pid)
    endscript
}
EOF

    log_ok "Post-installation setup complete"
}

create_systemd_service() {
    log_info "Creating systemd service..."

    cat > /etc/systemd/system/nginx.service << 'EOF'
[Unit]
Description=nginx - high performance web server
Documentation=https://nginx.org/en/docs/
After=network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target

[Service]
Type=forking
PIDFile=run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t -q
ExecStart=/usr/sbin/nginx
ExecReload=/bin/sh -c "/bin/kill -s HUP $(/bin/cat /var/run/nginx.pid)"
ExecStop=/bin/sh -c "/bin/kill -s QUIT $(/bin/cat /var/run/nginx.pid)"

# Performance tuning for high-concurrency CDN workloads
# Matches sysctl: fs.file-max=2097152, fs.nr_open=2097152
LimitNOFILE=2097152
LimitNPROC=infinity
LimitCORE=infinity

# Security hardening
PrivateTmp=true
ProtectSystem=full
NoNewPrivileges=true

TimeoutStartSec=0
TimeoutStopSec=5
KillMode=mixed
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable nginx

    log_ok "Systemd service created and enabled"
}

enable_ktls() {
    log_info "Configuring KTLS kernel module..."

    # Load TLS module
    modprobe tls 2>/dev/null || log_warn "TLS module not available in kernel"

    # Persist across reboots
    echo "tls" > /etc/modules-load.d/tls.conf

    log_ok "KTLS configuration complete"
}

verify_installation() {
    log_info "Verifying installation..."

    echo ""
    echo "==============================================================================="
    echo "nginx Installation Verification"
    echo "==============================================================================="

    # Version info
    echo ""
    echo "nginx version:"
    /usr/sbin/nginx -V 2>&1 | head -1

    echo ""
    echo "OpenSSL version:"
    /usr/sbin/nginx -V 2>&1 | grep -o "OpenSSL [0-9.]*[a-z]*" | head -1

    echo ""
    echo "Built with:"
    /usr/sbin/nginx -V 2>&1 | grep -E "(--with-pcre|--with-zlib|--with-openssl)" | tr ' ' '\n' | grep -E "^--with-(pcre|zlib|openssl)" | head -3

    # KTLS check
    echo ""
    echo "KTLS support:"
    if /usr/sbin/nginx -V 2>&1 | grep -q "enable-ktls"; then
        echo "  ✓ OpenSSL compiled with KTLS"
    else
        echo "  ✗ KTLS not detected in OpenSSL"
    fi

    if lsmod | grep -q "^tls"; then
        echo "  ✓ Kernel TLS module loaded"
    else
        echo "  ✗ Kernel TLS module not loaded"
    fi

    # Config test
    echo ""
    echo "Configuration test:"
    if /usr/sbin/nginx -t 2>&1; then
        echo "  ✓ Configuration valid"
    fi

    echo ""
    echo "==============================================================================="
    log_ok "Installation verification complete"
}

main() {
    echo ""
    echo "==============================================================================="
    echo "nginx ${NGINX_VERSION} Build Script"
    echo "Optimized for High-Performance CDN Workloads"
    echo "==============================================================================="
    echo ""

    preflight_checks
    install_dependencies
    create_nginx_user
    prepare_build_dir
    download_sources
    build_zlib
    build_pcre2
    build_openssl
    build_nginx
    post_install
    create_systemd_service
    enable_ktls
    verify_installation
}
main "$@"
