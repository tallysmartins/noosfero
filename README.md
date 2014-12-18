[![Code Climate](https://codeclimate.com/github/fabio1079/noosfero-plugin/badges/gpa.svg)](https://codeclimate.com/github/fabio1079/noosfero-plugin)

README - MPOG Software Público Plugin
================================

MPOG Software Público Plugin is a plugin that includes features to Novo Portal do Software Público Brasileiro (SPB).

More information about SPB: https://www.participa.br/softwarepublico

INSTALL
=======

Enable Plugin
-------------

Also, you need to enable MPOG Software Plugin on your Noosfero:

cd <your_noosfero_dir>
./script/noosfero-plugins enable mpog_software

Activate Plugin
---------------

As a Noosfero administrator user, go to administrator panel:

- Execute the command to allow city and states to show up:
  psql -U USERNAME -d NOOSFERO_DATABASE -a -f db/brazil_national_regions.sql
- Click on "Enable/disable plugins" option
- Click on "MPOG Software Plugin" check-box

Schedule Institutions Update
----------------------------

./plugins/mpog_software/script/schedule_institution_update.sh


Create Categories
-------------------

To create the categories that a software can have run

rake software:create_categories


Translate Plugin
------------------

To translate the strings used in the plugin run

ruby script/move-translations-to-plugins.rb
rake updatepo
rake noosfero:translations:compile


Running MPOG Software tests
--------------------
$ ruby plugins/mpog_software/test/unit/name_of_file.rb
$ cucumber plugins/mpog_software/features/

Get Involved
============

If you find any bug and/or want to collaborate, please send an e-mail to arthurmde@gmail.com

LICENSE
=======

Copyright (c) The Author developers.

See Noosfero license.


AUTHORS
=======

Alex Campelo (campelo.al1 at gmail.com)
Arthur de Moura Del Esposte (arthurmde at gmail.com)
Daniel Bucher (daniel.bucher88 at gmail.com)
David Carlos (ddavidcarlos1392 at gmail.com)
Fabio Teixeira (fabio1079 at gmail.com)
Gustavo Jaruga (darksshades at gmail.com)
Luciano Prestes (lucianopcbr at gmail.com)
Matheus Faria (matheus.sousa.faria at gmail.com)


ACKNOWLEDGMENTS
===============

The authors have been supported by MPOG and UnB
