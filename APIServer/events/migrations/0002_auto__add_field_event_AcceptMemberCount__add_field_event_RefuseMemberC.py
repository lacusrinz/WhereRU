# -*- coding: utf-8 -*-
from south.utils import datetime_utils as datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):
        # Adding field 'Event.AcceptMemberCount'
        db.add_column(u'events_event', 'AcceptMemberCount',
                      self.gf('django.db.models.fields.IntegerField')(default=0),
                      keep_default=False)

        # Adding field 'Event.RefuseMemberCount'
        db.add_column(u'events_event', 'RefuseMemberCount',
                      self.gf('django.db.models.fields.IntegerField')(default=0),
                      keep_default=False)

        # Adding field 'Participants.status'
        db.add_column(u'events_participants', 'status',
                      self.gf('django.db.models.fields.CharField')(default='', max_length=8, blank=True),
                      keep_default=False)


    def backwards(self, orm):
        # Deleting field 'Event.AcceptMemberCount'
        db.delete_column(u'events_event', 'AcceptMemberCount')

        # Deleting field 'Event.RefuseMemberCount'
        db.delete_column(u'events_event', 'RefuseMemberCount')

        # Deleting field 'Participants.status'
        db.delete_column(u'events_participants', 'status')


    models = {
        u'events.event': {
            'AcceptMemberCount': ('django.db.models.fields.IntegerField', [], {}),
            'Message': ('django.db.models.fields.TextField', [], {}),
            'Meta': {'ordering': "['startdate']", 'object_name': 'Event'},
            'RefuseMemberCount': ('django.db.models.fields.IntegerField', [], {}),
            'createdBy': ('django.db.models.fields.CharField', [], {'max_length': '100'}),
            'createdDate': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'latitude': ('django.db.models.fields.CharField', [], {'max_length': '100'}),
            'longitude': ('django.db.models.fields.CharField', [], {'max_length': '100'}),
            'modifiedBy': ('django.db.models.fields.CharField', [], {'max_length': '100'}),
            'modifiedDate': ('django.db.models.fields.DateTimeField', [], {'auto_now': 'True', 'blank': 'True'}),
            'needLocation': ('django.db.models.fields.BooleanField', [], {}),
            'owner': ('django.db.models.fields.related.ForeignKey', [], {'related_name': "'owner'", 'blank': 'True', 'to': u"orm['users.AppUser']"}),
            'startdate': ('django.db.models.fields.DateTimeField', [], {})
        },
        u'events.participants': {
            'Meta': {'object_name': 'Participants'},
            'event': ('django.db.models.fields.related.ForeignKey', [], {'related_name': "'eventParticipants'", 'to': u"orm['events.Event']"}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'participant': ('django.db.models.fields.related.ForeignKey', [], {'related_name': "'participant'", 'to': u"orm['users.AppUser']"}),
            'status': ('django.db.models.fields.CharField', [], {'max_length': '8', 'blank': 'True'})
        },
        u'users.appuser': {
            'From': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'Meta': {'object_name': 'AppUser'},
            'avatar': ('django.db.models.fields.CharField', [], {'max_length': '255', 'blank': 'True'}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'is_active': ('django.db.models.fields.BooleanField', [], {'default': 'True'}),
            'is_admin': ('django.db.models.fields.BooleanField', [], {'default': 'False'}),
            'is_social': ('django.db.models.fields.BooleanField', [], {'default': 'False'}),
            'last_login': ('django.db.models.fields.DateTimeField', [], {'default': 'datetime.datetime.now'}),
            'nickname': ('django.db.models.fields.CharField', [], {'max_length': '255'}),
            'password': ('django.db.models.fields.CharField', [], {'max_length': '128'}),
            'username': ('django.db.models.fields.CharField', [], {'unique': 'True', 'max_length': '255'})
        }
    }

    complete_apps = ['events']