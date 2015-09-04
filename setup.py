#!/usr/bin/env python
"""
colab-spb-theme plugin
======================
The Brazilian Public Software Portal theme for Colab.
"""
from setuptools import setup, find_packages

install_requires = ['colab']

setup(
    name="colab-spb-theme",
    version='0.1.0',
    author='Carlos Oliveira',
    author_email='carlospecter@gmail.com',
    url='https://portal.softwarepublico.gov.br/gitlab/softwarepublico/colab-spb-theme',
    description='The Brazilian Public Software Portal theme for Colab',
    long_description=__doc__,
    license='GPLv3',
    package_dir={'': 'src'},
    packages=find_packages('src'),
    zip_safe=False,
    install_requires=install_requires,
    include_package_data=True,
    classifiers=[
        'Framework :: Django',
        'Intended Audience :: Developers',
        'Intended Audience :: System Administrators',
        'Operating System :: OS Independent',
        'Topic :: Software Development'
    ],
)
