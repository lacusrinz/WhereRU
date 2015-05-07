from rest_framework.response import Response
from rest_framework import status
from events.models import Event, Participants
from events.serializers import EventSerializer, ParticipantSerializer
from djoser.serializers import UserSerializer

from rest_framework.authentication import TokenAuthentication, BasicAuthentication, SessionAuthentication, OAuth2Authentication
from rest_framework.permissions import IsAuthenticated
from rest_framework import filters
from rest_framework import viewsets
from rest_framework.decorators import detail_route, list_route

from StringIO import StringIO
from django.contrib.auth import get_user_model

import sys 
import json
from itertools import chain


User = get_user_model()

reload(sys) 
sys.setdefaultencoding('utf8')

class EventViewSet(viewsets.ModelViewSet):
	authentication_classes = (TokenAuthentication,SessionAuthentication)#(SessionAuthentication, TokenAuthentication, BasicAuthentication)
	permission_classes = (IsAuthenticated,)

	queryset = Event.objects.all()
	serializer_class = EventSerializer

	@detail_route(methods=['post'])
	def set_participants(self, request, pk=None):
		event = self.get_object()
		event.owner = self.request.user
		event.save()
		Participants.objects.filter(event_id=event.id).delete()
		data = request.DATA
		print data
		for d in data.values():
			user = User.objects.get(nickname=d)
			participant = Participants.objects.create(event=event, participant=user)
			participant.save()
		content = {'status_code':'201', 'detail': 'Add Participants Success!'}
		return Response(content, status=status.HTTP_201_CREATED)

	@list_route()
	def invite(self,request):
		print request.user
		mineEvent = Event.objects.filter(owner=request.user)
		# otherEvent = Event.objects.filter(eventParticipants__participant=request.user)
		# event = []
		# event.extend(mineEvent)
		# event.extend(otherEvent)
		count = len(mineEvent)
		serializer = EventSerializer(mineEvent, many=True)
		content = {'count':count, 'results': serializer.data}
		return Response(content)

	@list_route()
	def invited(self,request):
		print request.user
		# mineEvent = Event.objects.filter(owner=request.user)
		otherEvent = Event.objects.filter(eventParticipants__participant=request.user)
		# event = []
		# event.extend(mineEvent)
		# event.extend(otherEvent)
		count = len(otherEvent)
		serializer = EventSerializer(otherEvent, many=True)
		content = {'count':count, 'results': serializer.data}
		return Response(content)



class ParticipantViewSet(viewsets.ModelViewSet):
	authentication_classes = (TokenAuthentication,SessionAuthentication)#(SessionAuthentication, TokenAuthentication, BasicAuthentication)
	permission_classes = (IsAuthenticated,)

	queryset = Participants.objects.all()
	serializer_class = ParticipantSerializer


	@list_route()
	def my_event_status(self, request):
		eventid = request.QUERY_PARAMS['eventid']
		participant = Participants.objects.filter(event=eventid ,participant=request.user)
		print participant
		serializer = ParticipantSerializer(participant)
		content = {'results': serializer.data}
		return Response(content)

	@list_route()
	def by_event(self, request):
		eventid = request.QUERY_PARAMS['eventid']
		participantsArray=[]
		participants = Participants.objects.filter(event=eventid)
		for p in participants:
			print p.participant
			participantsArray.append(p.participant)
		print participantsArray
		count = len(participantsArray)
		print count
		serializer = UserSerializer(participantsArray, many=True)
		print serializer.data
		content = {'count':count, 'results': serializer.data}
		return Response(content)
		


