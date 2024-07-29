import logging

logging.basicConfig(level=logging.INFO)
logging.getLogger("botocore.hooks").setLevel(logging.WARNING)
logging.getLogger("botocore.auth").setLevel(logging.WARNING)
logging.getLogger("botocore.credentials").setLevel(logging.WARNING)
logging.getLogger("botocore.regions").setLevel(logging.WARNING)
logging.getLogger("botocore.endpoint").setLevel(logging.WARNING)
logging.getLogger("botocore.parsers").setLevel(logging.WARNING)
logging.getLogger("botocore.retryhandler").setLevel(logging.WARNING)
logging.getLogger("botocore").setLevel(logging.WARNING)

logging.getLogger("suds.client").setLevel(logging.DEBUG)
logging.getLogger("suds").setLevel(logging.DEBUG)

logging.getLogger("urllib3.connectionpool").setLevel(logging.WARNING)

print("SET default logging")
