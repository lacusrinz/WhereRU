from rest_framework import serializers
from events.models import Event, Participants

class EventSerializer(serializers.ModelSerializer):
	eventParticipants = serializers.RelatedField(many=True)
	class Meta:
		model = Event
		fields = ('id', 'owner', 'eventParticipants', 'latitude', 'longitude', 'startdate', 'needLocation', 'Message', 'AcceptMemberCount', 'RefuseMemberCount')

class ParticipantSerializer(serializers.ModelSerializer):
	# eventid = serializers.Field(source='Event.id')
	class Meta:
		model = Participants
		fields = ('id', 'event', 'participant', 'status')