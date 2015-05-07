from rest_framework import serializers
from django.contrib.auth import get_user_model
from friends.models import Friendship, FriendshipInvitation


User = get_user_model()

class UsersSerializer(serializers.HyperlinkedModelSerializer):
	class Meta:
		model = User
		fields = ('nickname','avatar',)