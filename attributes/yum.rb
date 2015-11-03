def jml_mirror_for(repo, options = {})
  version = options[:version] || '7'
  arch = options[:arch] || 'x86_64'
  "http://mirrors.jmorgan.org/centos/#{version}/#{repo}/#{arch}"
end

if platform? 'centos'
  override['yum']['base']['enabled'] = true
  override['yum']['base']['managed'] = true
  override['yum']['base']['mirrorlist'] = nil
  override['yum']['base']['baseurl'] = jml_mirror_for('base')
  override['yum']['base']['sslverify'] = false

  override['yum']['contrib']['enabled'] = true
  override['yum']['contrib']['managed'] = true
  override['yum']['contrib']['mirrorlist'] = nil
  override['yum']['contrib']['baseurl'] = jml_mirror_for('contrib')
  override['yum']['contrib']['sslverify'] = false

  override['yum']['extras']['enabled'] = true
  override['yum']['extras']['managed'] = true
  override['yum']['extras']['mirrorlist'] = nil
  override['yum']['extras']['baseurl'] = jml_mirror_for('extras')
  override['yum']['extras']['sslverify'] = false

  override['yum']['centosplus']['enabled'] = true
  override['yum']['centosplus']['managed'] = true
  override['yum']['centosplus']['mirrorlist'] = nil
  override['yum']['centosplus']['baseurl'] = jml_mirror_for('centosplus')
  override['yum']['centosplus']['sslverify'] = false

  override['yum']['updates']['enabled'] = true
  override['yum']['updates']['managed'] = true
  override['yum']['updates']['mirrorlist'] = nil
  override['yum']['updates']['baseurl'] = jml_mirror_for('updates')
  override['yum']['updates']['sslverify'] = false

  override['yum']['fasttrack']['enabled'] = true
  override['yum']['fasttrack']['managed'] = true
  override['yum']['fasttrack']['mirrorlist'] = nil
  override['yum']['fasttrack']['baseurl'] = jml_mirror_for('fasttrack')
  override['yum']['fasttrack']['sslverify'] = false
end
