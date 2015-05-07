from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()

class Event(models.Model):
	owner = models.ForeignKey(User,related_name='owner', blank=True)
	latitude = models.CharField(max_length=100)
	longitude = models.CharField(max_length=100)
	startdate = models.DateTimeField()
	needLocation = models.BooleanField()
	Message = models.TextField()

	AcceptMemberCount = models.IntegerField()
	RefuseMemberCount = models.IntegerField()
	
	createdDate = models.DateTimeField(auto_now_add=True)
	createdBy = models.CharField(max_length=100)
	modifiedDate = models.DateTimeField(auto_now=True)
	modifiedBy = models.CharField(max_length=100)

	class Meta:
		ordering = ['startdate']

	def __unicode__(self):
		return '%s' % (self.Message)

class Participants(models.Model):
	event = models.ForeignKey(Event, related_name='eventParticipants')
	participant = models.ForeignKey(User, related_name = 'participant')
	status = models.CharField(max_length=8, blank=True)

	def __unicode__(self):
		return '%s' % (self.participant)
