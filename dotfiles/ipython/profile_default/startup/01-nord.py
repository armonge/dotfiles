import sys as _sys
import subprocess as _subprocess
import pkg_resources as _pkg_resources


def _should_install_requirement(requirement):
    should_install = False
    try:
        _pkg_resources.require(requirement)
    except (
        _pkg_resources.DistributionNotFound,
        _pkg_resources.VersionConflict,
    ):
        should_install = True
    return should_install


def _install_packages(requirement_list):
    try:
        requirements = [
            requirement
            for requirement in requirement_list
            if _should_install_requirement(requirement)
        ]
        if len(requirements) > 0:
            _subprocess.check_call(
                [_sys.executable, "-m", "pip", "install", *requirements]
            )

    except Exception as e:
        print(e)


_install_packages(["ipython_nord_theme"])

from ipython_nord_theme.startup import load as _load

_load()
print("nord loaded")
