import codecs
import os
import re

from setuptools import setup

# if you are not using vagrant, just delete os.link directly,
# The hard link only saves a little disk space, so you should not care
if os.environ.get('USER', '') == 'vagrant':
    del os.link

def read(*parts):
    return codecs.open(os.path.join(os.path.dirname(__file__), *parts),
                       encoding='utf8').read()


def find_version(*file_paths):
    version_file = read(*file_paths)
    version_match = re.search(r"^__version__ = ['\"]([^'\"]*)['\"]",
                              version_file, re.M)
    if version_match:
        return version_match.group(1)
    raise RuntimeError("Unable to find version string.")


setup(
    name='colab-spb',
    url='https://github.com/colab/colab-spb',
    description='Yet another Django reverse proxy application.',
    version=find_version('colab_spb/__init__.py'),
    long_description=read('README.rst'),
    packages=['colab_spb'],
    install_requires=[
        'colab',
    ],
    tests_require=['mock'],
    test_suite="tests.run.runtests",
    author='Sergio Oliveira',
    author_email='sergio@tracy.com.br',
    license='GPL 2.0',
    classifiers=[
        'Development Status :: 3 - Alpha',
        'Environment :: Web Environment',
        'Framework :: Django',
        'Intended Audience :: Developers',
        'Operating System :: OS Independent',
        'Programming Language :: Python',
        'Programming Language :: Python :: 2',
        'Programming Language :: Python :: 2.7',
        'Topic :: Internet :: WWW/HTTP',
        'Topic :: Internet :: WWW/HTTP :: Dynamic Content',
        'Topic :: Internet :: WWW/HTTP :: WSGI',
    ],
)
