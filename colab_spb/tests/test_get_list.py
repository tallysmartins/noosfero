# -*- coding: utf-8 -*-
from django.test import TestCase, Client


class ColabSPB(TestCase):

    fixtures = ['colab_spb.json']

    def setUp(self):
        super(ColabSPB, self).setUp()
        self.client = Client()

    def tearDown(self):
        pass

    def test_getlist_without_list(self):
        response = self.client.get("/spb/get_list/?list_name=")
        message = ("Não foi possível encontrada lista de discussão"
                   " associada a está comunidade, para mais"
                   " detalhes contacte o administrador.")
        self.assertEqual(message, response.content)
        self.assertEqual(404, response.status_code)

    def test_getlist_with_list(self):
        response = self.client.get("/spb/get_list/?list_name=ListA&MAX=5")
        self.assertEqual(5, len(response.context[1]['latest']))

    def test_getlist_default_MAX(self):
        response = self.client.get("/spb/get_list/?list_name=ListA")
        self.assertEqual(7, len(response.context[1]['latest']))

    def test_getlist_invalid_MAX(self):
        response = self.client.get("/spb/get_list/?list_name=ListA&MAX=")
        self.assertEqual(7, len(response.context[1]['latest']))
