class Knotis < Formula
  include Language::Python::Virtualenv

  desc "Teaching-focused extension to Zensical"
  homepage "https://github.com/ttezcann/knotis"
  url "https://files.pythonhosted.org/packages/9f/af/8bfb8abe6a7cc6000cfbbf047ba73a4738f0a2242d781cb38b353af37bdb/knotis-0.1.10.tar.gz"
  sha256 "b118a54362cfdb7d53255ab3cbbe697a6197ceb1cd3478945223d0507c70b6f0"
  license "MIT"

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.14"

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "deepmerge" do
    url "https://files.pythonhosted.org/packages/38/6e/5cb3548b4d3112fea529375e55e6f3cdc52b8054e3a66f203b1f888ba885/deepmerge-3.0.1.tar.gz"
    sha256 "35b39a4cb92cf328d6eca61cbbf65f68a37c2ceb3085f0f853cbb2e52a59fc23"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/f4/32/0b4d0297064244f04af4331b65de16237cc3cce07474171ee14222a28981/markdown-3.11.2.tar.gz"
    sha256 "87bf5d90f2d2882e2c02fcda182c2800456b985bff38913867c49706481514b0"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pymdown-extensions" do
    url "https://files.pythonhosted.org/packages/f3/fe/ac50ee24a80a1b344e643f6fb626063cc7041b978cd1dd9a7f9963ae1cd1/pymdown_extensions-12.3.tar.gz"
    sha256 "a7f2a4e0bc60c6e6babfa7922cfb3b01cd640eb00fb208f3c582e12bae00ea67"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/b0/78/9ad63712633ed3ab5cc1a648d863d7e7da371e9425e209555a0fe711b695/tomli-2.5.0.tar.gz"
    sha256 "264507556cd8b8c8e7c6ee037cdf443a463f03f4c958e57195e3d369711b8ff6"
  end

  resource "zensical" do
    url "https://files.pythonhosted.org/packages/bf/02/e10dc98fc5e204500a2b208624696bba28afdac5a3aaa399e4252f4fa1fd/zensical-0.0.72.tar.gz"
    sha256 "2801fcd8baec6e4d14ada113e03a6fb4c6ec2efa2518dc0ae94ee54ed71c94f1"
  end

  allow_network_access! :build
  deny_network_access! :test

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV.delete "KNOTIS_SKIP_ZENSICAL_VERSION_CHECK"
    system libexec/"bin/python", "-c", <<~PYTHON
      from importlib.metadata import requires, version
      from knotis.zensical_runtime import ZENSICAL_REQUIREMENT
      assert version("knotis") == "#{version}"
      dependency = "zensical==" + version("zensical")
      assert dependency == ZENSICAL_REQUIREMENT
      assert dependency in requires("knotis")
    PYTHON
    system bin/"knotis", "new", "."
    assert_path_exists testpath/"zensical.toml"
    assert_path_exists testpath/"site/index.html"
    assert_path_exists testpath/"site/assets/knotis/knotis-core.js"
    system bin/"knotis", "build"
    assert_path_exists testpath/"site/assets/knotis/knotis-search.json"
  end
end
