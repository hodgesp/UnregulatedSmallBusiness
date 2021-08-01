resource "google_compute_instance" "new1" {
  name         = "new1" # name of the server
  machine_type = var.machine_type # machine type refer google machine types
  zone         = "${var.region}-a" # `a` zone of the selected region in our case us-central-1a
  tags         = ["externalssh","webserver"] # selecting the vm instances with tags

  # to create a startup disk with an Image/ISO. 
  # here we are choosing the CentOS7 image
  boot_disk { 
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }

  # We can create our own network or use the default one like we did here
  network_interface {
    network = google_compute_network.vpc_network.name

    # assigning the reserved public IP to this instance
    access_config { }
 }

  # This is copy the the SSH public Key to enable the SSH Key based authentication
  metadata = {
    ssh-keys = "${var.user}:${file(var.publickeypath)}"
    #sshKeys = "${var.user}:${file (var.publickeypath)}"
  }
}

resource "google_compute_instance" "new2" {
  name         = "new2" # name of the server
  machine_type = var.machine_type # machine type refer google machine types
  zone         = "${var.region}-a" # `a` zone of the selected region in our case us-central-1a
  tags         = ["externalssh","webserver"] # selecting the vm instances with tags

  # to create a startup disk with an Image/ISO. 
  # here we are choosing the CentOS7 image
  boot_disk { 
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }

  # We can create our own network or use the default one like we did here
  network_interface {
    network = google_compute_network.vpc_network.name

    # assigning the reserved public IP to this instance
    access_config { }
  }

  # This is copy the the SSH public Key to enable the SSH Key based authentication
  metadata = {
    ssh-keys = "${var.user}:${file(var.publickeypath)}"
  }
}

resource "google_compute_instance" "new3" {
  name         = "new3" # name of the server
  machine_type = var.machine_type # machine type refer google machine types
  zone         = "${var.region}-a" # `a` zone of the selected region in our case us-central-1a
  tags         = ["externalssh","webserver"] # selecting the vm instances with tags

  # to create a startup disk with an Image/ISO. 
  # here we are choosing the CentOS7 image
  boot_disk { 
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }

  # We can create our own network or use the default one like we did here
  network_interface {
    network = google_compute_network.vpc_network.name

    # assigning the reserved public IP to this instance
   access_config { }
  }

  # This is copy the the SSH public Key to enable the SSH Key based authentication
  metadata = {
    ssh-keys = "${var.user}:${file(var.publickeypath)}"
  }
}
