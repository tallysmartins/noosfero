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
    version='0.2.0',
    author='Carlos Oliveira',
    author_email='carlospecter@gmail.com',
    url='https://portal.softwarepublico.gov.br/gitlab/softwarepublico/colab-spb-theme',
    description='The Brazilian Public Software Portal theme for Colab',
    long_description=__doc__,
    license='GPLv3',
    package_dir={'colab_spb_theme': 'colab_spb_theme'},
    packages=find_packages('colab_spb_theme'),
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
