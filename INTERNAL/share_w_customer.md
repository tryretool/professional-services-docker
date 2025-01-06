# Internal Packaging Note

To package and share with a customer (until we have a shareable repo).

* Download repo zip, [click here](https://github.com/tryretool/professional-services-docker/archive/refs/heads/main.zip)
* Repackage using script below
* Share `retool-docker-ps.zip` with customer.

```
# Get whole repo
unzip ~/Downloads/professional-services-docker-main.zip -d ~/
cd professional-services-docker-main

# Only necessary files
rm -rf INTERNAL* 

# Create zip file for customer
zip -r retool-docker-ps.zip *

# put it on desktop
cp retool-docker-ps.zip ~/Desktop/

# cleanup
cd
rm -rf professional-services-docker-main
```

And then share `~/Desktop/retool-docker-ps.zip` with customer.
