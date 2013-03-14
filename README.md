LogStash
========

This state is targeted at people who want to deploy a large-scale logstash implementation.

You will need to deploy the `logstash.cient` on all boxes that will be sending log events to logstash.
All this does is add a config file to rsyslog which sends logging events to the shipper.


salt_logstash_shipper
=====================

Install a logstash shipper. This is the client that sends logs out for analysis.
