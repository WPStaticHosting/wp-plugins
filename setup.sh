sudo apt update
sudo apt upgrade -y
sudo apt install sed

# ENABLE SSH
sudo rm -r /etc/ssh/sshd_not_to_be_run

# ENABLE LOGIN USING PASSWORD
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl restart ssh

# DISABLE BITNAMI BANNER
sudo /opt/bitnami/apps/wordpress/bnconfig --disable_banner 1
sudo /opt/bitnami/ctlscript.sh restart apache

cd /opt/bitnami/apps/wordpress/htdocs

# ADDING USER fazalfarhan01 AND DELETING DEFAULT
wp user create fazalfarhan01 fazal.farhan@gmail.com --role=administrator --user_pass=$1
wp user delete 1 --reassign=2

# DEACTIVATE AND DELETE ALL PLUGINS
wp plugin deactivate --all
wp plugin delete $(wp plugin list --status=inactive --field=name)

# INSTALL ASTRA
sudo wp theme install astra  --allow-root

# INSTALL OTHER PLUGINS
sudo wp plugin install all-in-one-wp-migration happy-elementor-addons \
essential-addons-for-elementor-lite elementskit-lite astra-sites \
envato-elements ele-custom-skin templately litespeed-cache \
https://github.com/WPStaticHosting/wp-plugins/raw/main/seo-by-rank-math.zip \
https://github.com/WPStaticHosting/wp-plugins/raw/main/elementor/elementor.zip \
https://github.com/WPStaticHosting/wp-plugins/raw/main/elementor/elementor-pro.zip \
https://github.com/WPStaticHosting/wp-plugins/raw/main/all-in-one-wp-migration-gdrive-extension.zip \
https://github.com/WPStaticHosting/wp-plugins/raw/main/wp-mail-smtp-pro_v2.8.0.zip \
https://github.com/WPStaticHosting/wp-plugins/raw/main/unlimited-elements-for-elementor-premium.zip \
https://github.com/WPStaticHosting/wp-plugins/raw/main/formidable-pro_v4.10.03.zip --force --allow-root

# CHANGE PERMISSIONS
sudo chown -R bitnami:daemon /opt/bitnami/apps/wordpress/htdocs/wp-content

# ACTIVATE ASTRA AND DELETE OTHER THEMES
wp theme activate astra
wp theme delete --all

# ACTIVATE ALL PLUGINS
wp plugin activate --all