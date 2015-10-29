# -*- coding: utf-8 -*-

from django.test import TestCase, Client


class SPBTest(TestCase):

    fixtures = ['colab_spb.json']

    def setUp(self):
        super(SPBTest, self).setUp()
        self.client = Client()

    def tearDown(self):
        pass

    def test_mail_list_without_list(self):
        response = self.client.get("/spb/mail_list/?community=")
        message = ("Não foi possível encontrada lista de discussão"
                   " associada a está comunidade, para mais"
                   " detalhes contate o administrador.")
        self.assertEqual(message, response.content)
        self.assertEqual(200, response.status_code)

    def test_mail_list_with_list(self):
        response = self.client.get("/spb/mail_list/"
                                   "?community=example_community&MAX=5")
        self.assertEqual(5, len(response.context[1]['latest']))

    def test_mail_list_default_MAX(self):
        response = self.client.get("/spb/mail_list/"
                                   "?community=example_community")
        self.assertEqual(7, len(response.context[1]['latest']))

    def test_mail_list_invalid_MAX(self):
        response = self.client.get("/spb/mail_list/"
                                   "?community=example_community&MAX=")
        self.assertEqual(7, len(response.context[1]['latest']))

    def test_gitlab_community_association_with_invalid_community(self):
        response = self.client.get("/spb/gitlab_activity/?community=")
        message = ("Esta comunidade não está associada a"
                   " nenhum repositório no momento, para mais"
                   " detalhes contate o administrador.")
        self.assertIn(message, response.content)
        self.assertEqual(dict(), response.context['community_association'])
        self.assertEqual(200, response.status_code)

    def test_gitlab_community_association_with_valid_community(self):
        response = self.client.get("/spb/gitlab_activity/"
                                   "?community=example_community")

        result = response.context['community_association']

        self.assertEqual(type(result), dict)
        self.assertEqual(result['community'], 'example_community')
        self.assertEqual(result['limit'], 7)
        self.assertEqual(result['offset'], 0)
        self.assertEqual(result['repository'],
                         '/gitlab/groups/example_community')
        self.assertEqual(result['mailman_list'], 'ListA')

    def test_gitlab_community_association_with_no_default_limit(self):
        response = self.client.get("/spb/gitlab_activity/"
                                   "?community=example_community"
                                   "&limit=5")

        result = response.context['community_association']

        self.assertEqual(type(result), dict)
        self.assertEqual(result['limit'], "5")

    def test_gitlab_community_association_with_no_default_offset(self):
        response = self.client.get("/spb/gitlab_activity/"
                                   "?community=example_community"
                                   "&offset=5")

        result = response.context['community_association']

        self.assertEqual(result['offset'], "5")
