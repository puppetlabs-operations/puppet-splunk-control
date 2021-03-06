## site.pp ##

# This file (/etc/puppetlabs/puppet/manifests/site.pp) is the main entry point
# used when an agent connects to a master and asks for an updated configuration.
#
# Global objects like filebuckets and resource defaults should go in this file,
# as should the default node definition. (The default node can be omitted
# if you use the console and don't define any other nodes in site.pp. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.)

## Active Configurations ##

# Disable filebucket by default for all File resources:
#http://docs.puppetlabs.com/pe/latest/release_notes.html#filebucket-resource-no-longer-created-by-default
File { backup => false }

# DEFAULT NODE
# Node definitions in this file are merged with node data from the console. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.

# The default node definition matches any node lacking a more specific node
# definition. If there are no other nodes in this file, classes declared here
# will be included in every node's catalog, *in addition* to any classes
# specified in the console for that node.

node default {
  #incude a role on any node that specifies it's role via a trusted fact at provision time
  #https://docs.puppetlabs.com/puppet/latest/reference/lang_facts_and_builtin_vars.html#trusted-facts
  #https://docs.puppetlabs.com/puppet/latest/reference/ssl_attributes_extensions.html#aws-attributes-and-extensions-population-example

  if !empty( $trusted['extensions']['pp_role'] ) {
    include "role::${trusted['extensions']['pp_role']}"
  }

  # This is where you can declare classes for all nodes.
  # Example:
  #   class { 'my_class': }

  if $::hostname =~ /^pe-.*/ {
    class { '::splunk::params':
      build => 'f44afce176d0',
      src_root => 'puppet:///modules/splunk_packages',
      server => '192.168.0.2',
    }

    class { '::splunk::forwarder':
      purge_inputs => true,
      purge_outputs => true,
      pkg_provider => 'rpm',
    }

    @splunkforwarder_input { 'puppetserver-index':
      section => 'monitor:///var/log/puppetlabs/puppetserver/puppetserver.log',
      setting => 'index',
      value   => 'puppet-enterprise',
      tag     => 'splunk_forwarder'
    }

    @splunkforwarder_input { 'puppetserver-sourcetype':
      section => 'monitor:///var/log/puppetlabs/puppetserver/puppetserver.log',
      setting => 'sourcetype',
      value   => 'puppetserver',
      tag     => 'splunk_forwarder'
    }

    @splunkforwarder_input { 'puppetserver-access-index':
      section => 'monitor:///var/log/puppetlabs/puppetserver/puppetserver-access.log',
      setting => 'index',
      value   => 'puppet-enterprise',
      tag     => 'splunk_forwarder'
    }

    @splunkforwarder_input { 'puppetserver-access-sourcetype':
      section => 'monitor:///var/log/puppetlabs/puppetserver/puppetserver-access.log',
      setting => 'sourcetype',
      value   => 'puppetserver_access',
      tag     => 'splunk_forwarder'
    }

    @splunkforwarder_input { 'puppetdb-index':
      section => 'monitor:///var/log/puppetlabs/puppetdb/puppetdb.log',
      setting => 'index',
      value   => 'puppet-enterprise',
      tag     => 'splunk_forwarder'
    }

    @splunkforwarder_input { 'puppetdb-sourcetype':
      section => 'monitor:///var/log/puppetlabs/puppetdb/puppetdb.log',
      setting => 'sourcetype',
      value   => 'puppetdb',
      tag     => 'splunk_forwarder'
    }

    @splunkforwarder_input { 'puppetdb-access-index':
      section => 'monitor:///var/log/puppetlabs/puppetdb/puppetdb-access.log',
      setting => 'index',
      value   => 'puppet-enterprise',
      tag     => 'splunk_forwarder'
    }

    @splunkforwarder_input { 'puppetdb-access-sourcetype':
      section => 'monitor:///var/log/puppetlabs/puppetdb/puppetdb-access.log',
      setting => 'sourcetype',
      value   => 'puppetdb_access',
      tag     => 'splunk_forwarder'
    }


    @splunkforwarder_input { 'consoleservices-index':
      section => 'monitor:///var/log/puppetlabs/console-services/console-services.log',
      setting => 'index',
      value   => 'puppet-enterprise',
      tag     => 'splunk_forwarder'
    }

    @splunkforwarder_input { 'consoleservices-sourcetype':
      section => 'monitor:///var/log/puppetlabs/console-services/console-services.log',
      setting => 'sourcetype',
      value   => 'consoleservices',
      tag     => 'splunk_forwarder'
    }

    @splunkforwarder_input { 'consoleservices-access-index':
      section => 'monitor:///var/log/puppetlabs/console-services/console-services-access.log',
      setting => 'index',
      value   => 'puppet-enterprise',
      tag     => 'splunk_forwarder'
    }

    @splunkforwarder_input { 'consoleservices-access-sourcetype':
      section => 'monitor:///var/log/puppetlabs/console-services/console-services-access.log',
      setting => 'sourcetype',
      value   => 'consoleservices_access',
      tag     => 'splunk_forwarder'
    }

  }

  if $::hostname =~ /^splunk-.*/ {

    class { '::splunk::params':
      src_root => 'puppet:///modules/splunk_packages',
    }

    class { '::splunk':
      pkg_provider => 'rpm',
    }
  }
}
