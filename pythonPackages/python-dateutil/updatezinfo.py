#!/usr/bin/env python
import os
import hashlib
import json
import io

from six.moves.urllib import request
from six.moves.urllib import error as urllib_error

from dateutil.zoneinfo import rebuild

METADATA_FILE = "zonefile_metadata.json"


def main():
    with io.open(METADATA_FILE, 'r') as f:
        metadata = json.load(f)

    releases_urls = metadata['releases_url']
    if metadata['metadata_version'] < 2.0:
        # In later versions the releases URL is a mirror URL
        releases_urls = [releases_urls]

    if not os.path.isfile(metadata['tzdata_file']):

        for ii, releases_url in enumerate(releases_urls):
            print("Downloading tz file from mirror {ii}".format(ii=ii))
            try:
                request.urlretrieve(os.path.join(releases_url,
                                                 metadata['tzdata_file']),
                                    metadata['tzdata_file'])
            except urllib_error.URLError as e:
                print("Download failed, trying next mirror.")
                last_error = e
                continue

            last_error = None
            break

        if last_error is not None:
            raise last_error

    with open(metadata['tzdata_file'], 'rb') as tzfile:
        sha_hasher = hashlib.sha512()
        sha_hasher.update(tzfile.read())
        sha_512_file = sha_hasher.hexdigest()
        assert metadata['tzdata_file_sha512'] == sha_512_file, "SHA failed for"
    print("Updating timezone information...")
    rebuild.rebuild(metadata['tzdata_file'], zonegroups=metadata['zonegroups'],
            metadata=metadata)
    print("Done.")

if __name__ == "__main__":
    main()
