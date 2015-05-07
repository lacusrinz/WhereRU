from django.shortcuts import render

from rest_framework import viewsets
from django.contrib.auth import get_user_model
from friends.serializers import UsersSerializer

from rest_framework.authentication import TokenAuthentication, BasicAuthentication, SessionAuthentication, OAuth2Authentication
from rest_framework.permissions import IsAuthenticated

User = get_user_model()

class UsersViewSet(viewsets.ReadOnlyModelViewSet):
	authentication_classes = (TokenAuthentication,)#(SessionAuthentication, TokenAuthentication, BasicAuthentication)
	permission_classes = (IsAuthenticated,)

	model = User
	serializer_class = UsersSerializer

	def get_queryset(self):
		return User.objects.exclude(username=self.request.user.username).exclude(username='admin')
