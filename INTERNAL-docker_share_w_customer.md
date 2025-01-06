# Internal Packaging Note

To package and share with a customer (until we have a shareable repo).

* Download repo zip, [click here](https://github.com/tryretool/proserv-scratch/archive/refs/heads/main.zip)
* Repackage using script below
* Share `retool-docker-ps.zip` with customer.

```
# Get whole repo
unzip ~/Downloads/proserv-scratch-main.zip -d ~/
cd proserv-scratch-main/docker/

# Only necessary files
rm INTERNAL* # remove this file

# Create zip file for customer
zip -r retool-docker-ps.zip *

# put it on desktop
cp retool-docker-ps.zip ~/Desktop/

# cleanup
cd
rm -rf ~/proserv-*
```

And then share `~/Desktop/retool-docker-ps.zip` with customer.
