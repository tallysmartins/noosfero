#!/usr/bin/env python
"""
colab-spb plugin
=================

A SPB plugin for Colab
"""
from setuptools import setup, find_packages

install_requires = ['colab', 'colab_noosfero', 'colab_gitlab']

tests_require = [ ]

setup(
    name='colab-spb',
    version='0.1.0',
    author='Macartur Sousa',
    author_email='macartur.sc@gmail.com',
    url='https://portal.softwarepublico.gov.br/gitlab/softwarepublico/colab-spb-plugin/',
    description='A Brazilian Public Software(Software Publico Brasileiro) plugin for Colab',
    long_description=__doc__,
    license='GPLv3',
    package_dir={'':'src'},
    packages=find_packages('src'),
    zip_safe=False,
    install_requires=install_requires,
    test_suite="tests.runtests.run",
    tests_require=tests_require,
    extras_require={'test':tests_require},
    include_package_data=True,
    classifiers=[
        'Framework :: Django',
        'Intended Audience :: Developers',
        'Intended Audience :: System Administrators',
        'Operating System :: OS Independent',
        'Topic :: Software Development'
    ],
)
