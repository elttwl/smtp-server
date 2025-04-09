#!/bin/bash
set -e

# 获取环境变量（默认值）
MY_USER=${MY_USER:-myuser}
MY_PASSWORD=${MY_PASSWORD:-mypassword}
MY_HOSTNAME=${MY_HOSTNAME:-example.com}
MY_DOMAIN=${MY_DOMAIN:-example.com}
MY_NETWORKS=${MY_NETWORKS:-0.0.0.0/0}

# 创建邮箱用户
if ! id "$MY_USER" &>/dev/null; then
  useradd -m -s /bin/bash "$MY_USER"
fi
echo "$MY_USER:$MY_PASSWORD" | chpasswd

# 动态生成 Postfix 配置文件
cat <<EOF > /etc/postfix/main.cf
# Main configuration for Postfix
myhostname = $MY_HOSTNAME
mydomain = $MY_DOMAIN
myorigin = \$mydomain
inet_interfaces = all
mydestination = \$myhostname, localhost.\$mydomain, localhost, \$mydomain
mynetworks = $MY_NETWORKS
smtpd_sasl_auth_enable = yes
smtpd_sasl_type = dovecot
smtpd_sasl_path = private/auth
smtpd_sasl_authenticated_header = yes
smtpd_recipient_restrictions = permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination
smtpd_tls_security_level = none
compatibility_level = 3.6
maillog_file = /dev/stdout
EOF

# 动态生成 Dovecot 配置文件
cat <<EOF > /etc/dovecot/conf.d/10-logging.conf
log_path = /dev/stdout
info_log_path = /dev/stdout
debug_log_path = /dev/stdout
EOF

cat <<EOF > /etc/dovecot/conf.d/10-master.conf
service auth {
  unix_listener /var/spool/postfix/private/auth {
    mode = 0660
    user = postfix
    group = postfix
  }
}
EOF

# 创建必要的目录并设置权限
mkdir -p /var/spool/postfix/private
chown postfix:postfix /var/spool/postfix/private
chmod 750 /var/spool/postfix/private

# 动态生成 Supervisord 配置文件
cat <<EOF > /etc/supervisor/supervisord.conf
[supervisord]
nodaemon=true
logfile=/dev/null
pidfile=/var/run/supervisord.pid

[program:postfix]
command=/usr/sbin/postfix start-fg
autostart=true
autorestart=true
stderr_logfile=/dev/stderr
stdout_logfile=/dev/stdout
stderr_logfile_maxbytes=0
stdout_logfile_maxbytes=0

[program:dovecot]
command=/usr/sbin/dovecot -F
autostart=true
autorestart=true
stderr_logfile=/dev/stderr
stdout_logfile=/dev/stdout
stderr_logfile_maxbytes=0
stdout_logfile_maxbytes=0
EOF

# 启动 supervisord
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
