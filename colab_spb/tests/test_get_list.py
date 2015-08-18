from django.http import HttpResponsePermanentRedirect
from django.test import TestCase, Client

from colab.super_archives.models import *

class ColabSPB(TestCase):

    fixtures = ['colab_spb.json']

    def setUp(self):
        super(ColabSPB, self).setUp()
        self.client = Client()

    def tearDown(self):
        pass

    def test_getlist_without_list(self):
        response = self.client.get("/spb/get_list/?list_name=")
        self.assertEqual("",response.content)
        self.assertEqual(404,response.status_code)

    def test_getlist_with_list(self):
        response = self.client.get("/spb/get_list/?list_name=ListA&MAX=5")
        self.assertEqual(5,len(response.context[1]['latest']))

    def test_getlist_default_MAX(self):
        response = self.client.get("/spb/get_list/?list_name=ListA")
        self.assertEqual(7,len(response.context[1]['latest']))

    def test_getlist_invalid_MAX(self):
        response = self.client.get("/spb/get_list/?list_name=ListA&MAX=")
        self.assertEqual(7,len(response.context[1]['latest']))
