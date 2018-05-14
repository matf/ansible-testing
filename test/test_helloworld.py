def test_helloworld(host):
    """
    Test for the helloworld role
    """
    hellofile = host.file("/etc/hello")
    assert hellofile.content_string == "world"
