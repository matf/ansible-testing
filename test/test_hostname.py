def test_hostname(host):
    """
    Simple example test checking the static hostname of the target container
    """
    hostname = host.check_output("hostname -s")
    assert hostname == "targethost"
