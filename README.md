# s3del

[Wercker] step to delete a file from [Amazon S3].

You can use application and deployment variables in wercker.

## Options

* `key-id` (required) The Amazon Access key that will be used for authorization.
* `key-secret` (required) The Amazon Access secret that will be used for authorization.
* `url` (required) The S3 URL denoting the file's destination.

## Example

    - s3del:
        key-id:     $KEY
        key-secret: $SECRET
        url:        s3://mybucket/myproject-latest.tar.gz

[Wercker]: http://wercker.com
[Amazon S3]: http://aws.amazon.com/s3
