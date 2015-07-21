from django.shortcuts import render
from django.http import HttpResponse

def get_list(request,path=None,list_name=None):
    return HttpResponse('Hello Word')
