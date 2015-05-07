# -*- coding: utf-8 -*-
from south.utils import datetime_utils as datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):
        # Adding model 'Event'
        db.create_table(u'events_event', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('owner', self.gf('django.db.models.fields.related.ForeignKey')(related_name='owner', blank=True, to=orm['users.AppUser'])),
            ('latitude', self.gf('django.db.models.fields.CharField')(max_length=100)),
            ('longitude', self.gf('django.db.models.fields.CharField')(max_length=100)),
            ('startdate', self.gf('django.db.models.fields.DateTimeField')()),
            ('needLocation', self.gf('django.db.models.fields.BooleanField')()),
            ('Message', self.gf('django.db.models.fields.TextField')()),
            ('createdDate', self.gf('django.db.models.fields.DateTimeField')(auto_now_add=True, blank=True)),
            ('createdBy', self.gf('django.db.models.fields.CharField')(max_length=100)),
            ('modifiedDate', self.gf('django.db.models.fields.DateTimeField')(auto_now=True, blank=True)),
            ('modifiedBy', self.gf('django.db.models.fields.CharField')(max_length=100)),
        ))
        db.send_create_signal(u'events', ['Event'])

        # Adding model 'Participants'
        db.create_table(u'events_participants', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('event', self.gf('django.db.models.fields.related.ForeignKey')(related_name='eventParticipants', to=orm['events.Event'])),
            ('participant', self.gf('django.db.models.fields.related.ForeignKey')(related_name='participant', to=orm['users.AppUser'])),
        ))
        db.send_create_signal(u'events', ['Participants'])


    def backwards(self, orm):
        # Deleting model 'Event'
        db.delete_table(u'events_event')

        # Deleting model 'Participants'
        db.delete_table(u'events_participants')


    models = {
        u'events.event': {
            'Message': ('django.db.models.fields.TextField', [], {}),
            'Meta': {'ordering': "['startdate']", 'object_name': 'Event'},
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
            'participant': ('django.db.models.fields.related.ForeignKey', [], {'related_name': "'participant'", 'to': u"orm['users.AppUser']"})
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