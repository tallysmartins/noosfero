.. -*- coding: utf-8 -*-

.. highlight:: rest

.. _colab_software:

=================================
Colab-Spb - A Gitlab-Noosfero Connector for the SPB
=================================



What is Colab?
==============

Application that integrates existing systems to represent the contributions of the members through:

* Discussions at the mailman list.

* And other systems in the community.



Features
========

* Developed by Interlegis Communities http://colab.interlegis.leg.br/

* Written in Python http://python.org/

* Built with Django Web Framework https://www.djangoproject.com/

* Search engine with Solr https://lucene.apache.org/solr/



Installation
============

After installing the colab

.. code-block::

  pip install colab-spb

Create a colab plugin configuration fila with at least the following:

.. code-block::

  vim /etc/colab/plugins.d/colab_spb.py

  name='colab_spb'

Running Colab
=============

To run Colab with development server you will have to:

1- Create the example configuration file:

.. code-block::

  colab-init-config > /etc/colab/settings.py

2- Edit the configuration file. Make sure you set everything you need including **database** credentials.

3- Run the development server:

.. code-block::

  colab-admin runserver 0.0.0.0:8000


**NOTE**: In case you want to keep the configuration file else where just set the
desired location in environment variable **COLAB_SETTINGS**.
