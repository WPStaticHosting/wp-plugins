# LAST UPDATED 2021-05-27

clear
read -p "Enter WordPress username: "  username
read -p "Enter WordPress admin e-mail: "  adminEmail
read -s -p "Enter Password: " pswd

clear
echo "Welcome $username!"

read -p "Enter Blog Name: "  blogName

sudo apt update
# sudo apt upgrade -y
sudo apt install sed

# ENABLE SSH
sudo rm -r /etc/ssh/sshd_not_to_be_run

# ENABLE LOGIN USING PASSWORD
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl restart ssh

# DISABLE BITNAMI BANNER
# sudo /opt/bitnami/apps/wordpress/bnconfig --disable_banner 1
# BANNER DISCONTINUED BY DEFAULT
sudo /opt/bitnami/ctlscript.sh restart apache

cd /opt/bitnami/wordpress

# ADDING USER fazalfarhan01 AND DELETING DEFAULT
sudo wp user create fazalfarhan01 fazal.farhan@gmail.com --role=administrator --user_pass=$pswd
sudo wp user delete 1 --reassign=2

# DEACTIVATE AND DELETE ALL PLUGINS
sudo wp plugin deactivate --all
sudo wp plugin delete $(sudo wp plugin list --status=inactive --field=name)

# DELETE ALL DEFAULT POSTS
sudo wp post delete $(sudo wp post list --field=ID)

# CHANGING PERMALINK STRUCTURE
sudo wp rewrite structure /%postname%/

# INSTALL ASTRA
# sudo wp theme install astra --allow-root
sudo wp theme install astra
# WORKS WITHOUT --allow-root

# INSTALL OTHER PLUGINS
sudo wp plugin install all-in-one-wp-migration happy-elementor-addons \
essential-addons-for-elementor-lite elementskit-lite astra-sites \
envato-elements ele-custom-skin templately litespeed-cache formidable \
https://github.com/WPStaticHosting/wp-plugins/raw/main/seo/seo-by-rank-math.zip \
https://github.com/WPStaticHosting/wp-plugins/raw/main/seo/seo-by-rank-math-pro.zip \
https://github.com/WPStaticHosting/wp-plugins/raw/main/elementor/elementor.zip \
https://github.com/WPStaticHosting/wp-plugins/raw/main/elementor/elementor-pro.zip \
https://github.com/WPStaticHosting/wp-plugins/raw/main/all-in-one-wp-migration-gdrive-extension.zip \
https://github.com/WPStaticHosting/wp-plugins/raw/main/wp-mail-smtp-pro_v2.8.0.zip \
https://github.com/WPStaticHosting/wp-plugins/raw/main/unlimited-elements-for-elementor-premium.zip \
https://github.com/WPStaticHosting/wp-plugins/raw/main/formidable-pro_v4.10.03.zip --force
# WORKS WITHOUT --allow-root


# CHANGE PERMISSIONS TO MAKE WRITEABLE
sudo chown -R bitnami:daemon /opt/bitnami/wordpress/.
sudo chmod 775 -R /opt/bitnami/wordpress/.
sudo chmod 775 -R /bitnami/wordpress

# ACTIVATE ASTRA AND DELETE OTHER THEMES
sudo wp theme activate astra
sudo wp theme delete --all

# ACTIVATE ALL PLUGINS
sudo wp plugin activate --all

sudo wp option update blogname "$blogName"
sudo wp option update admin_email "$adminEmail"

sudo wp option update timezone_string "Asia/Kolkata"