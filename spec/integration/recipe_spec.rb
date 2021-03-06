require "spec_helper"

describe file("/etc/cron.d/idcf-backup_to_object_storage") do
  it { should be_file }
  it { should be_owned_by "root" }
  it { should be_grouped_into "root" }
  it { should contain "1 * * * * root /bin/bash /opt/idcf/backup_to_object_storage.sh PATH1 BUCKET1 7 > /dev/null 2>&1" }
  it { should contain "1 * * * * root /bin/bash /opt/idcf/backup_to_object_storage.sh PATH2 BUCKET2 7 'tar zcf /backup/path2/backup_`date +\\%Y\\%m\\%d\\%H\\%M`.tar.gz /backup/source' > /dev/null 2>&1" }
end

describe file("/etc/s3cmd/idcf/backup_to_object_storage.cfg") do
  it { should be_file }
  it { should contain "access_key = SPEC_ACCESS_KEY" }
  it { should contain "host_base = ds.jp-east.idcfcloud.com" }
  it { should contain "host_bucket = %(bucket)s.ds.jp-east.idcfcloud.com" }
  it { should contain "secret_key = SPEC_SECRET_KEY" }
  it { should contain "signature_v2 = True" }
end

describe file("/opt/idcf/backup_to_object_storage.sh") do
  it { should be_file }
  it { should be_executable }
  it { should be_owned_by "root" }
  it { should be_grouped_into "root" }
  its(:content) { should match %r(^#!/bin/bash)m }
end
