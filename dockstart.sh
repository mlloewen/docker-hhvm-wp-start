#bash
sudo docker run -d -p 8080:80 --name wp -v /home/lesi/repos/wordpress/wp-content/themes:/data/src/html/wordpress/wp-content/themes -v /home/lesi/repos/wordpress/wp-content/plugins:/data/src/html/wordpress/wp-content/plugins mlloewen/wprevisr