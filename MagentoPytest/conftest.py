import pytest
import logging

@pytest.hookimpl(tryfirst=True)
def pytest_configure(config):
    # Safe check to avoid AttributeError if pytest-html is not active
    if hasattr(config, '_metadata'):
        config._metadata['Project'] = "Magento"
        config._metadata['Tester'] = "AngeruRobert"