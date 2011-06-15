# Sequreisp - Copyright 2010, 2011 Luciano Ruete
#
# This file is part of Sequreisp.
#
# Sequreisp is free software: you can redistribute it and/or modify
# it under the terms of the GNU Afero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Sequreisp is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Afero General Public License for more details.
#
# You should have received a copy of the GNU Afero General Public License
# along with Sequreisp.  If not, see <http://www.gnu.org/licenses/>.

class Configuration < ActiveRecord::Base

  def self.acts_as_audited_except
    [:daemon_reload]
  end

  acts_as_audited :except => self.acts_as_audited_except
  
  validates_presence_of :default_tcp_prio_ports, :default_prio_protos, :default_prio_helpers, :mtu, :quantum_factor, :nf_conntrack_max, :gc_thresh1, :gc_thresh2, :gc_thresh3
  validates_presence_of :notification_email, :if => Proc.new { |c| c.deliver_notifications? }
  validates_presence_of :notification_timeframe
  validates_presence_of :language
  
  validates_format_of :default_tcp_prio_ports, :default_udp_prio_ports, :default_prio_protos, :default_prio_helpers, :with => /^([0-9a-z-]+,)*[0-9a-z-]+$/, :allow_blank => true

  validates_numericality_of :notification_timeframe, :only_integer => true, :greater_than_or_equal_to => 0

  def validate
    if !notification_email.blank?
      invalid=false
      notification_email.split(",").each do |ne|
        invalid ||= ((ne =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i) == nil)
      end
      errors.add("notification_email", I18n.t('validations.configuration.notification_email_invalid')) if invalid
    end
  end

  private_class_method :new, :create, :destroy, :destroy_all, :delete, :delete_all

  @@c = find(:first) rescue nil

  def self.do_reload
    @@c = find(:first)
  end

  def self.method_missing(method, *args)
    opcion = method.to_s
    if opcion.include? '='
        # Asignar un valor a la opción
        valor = args.first
        @@c.send opcion, valor
      else
        # Retornar el valor de la opción
        @@c.send opcion
    end
  end

  def self.save
    @@c.save
  end

  def self.update_attributes(atributos)
    @@c.update_attributes(atributos)
  end

  def self.errors
    @@c.errors
  end
  def save_without_timestamps
    Configuration.record_timestamps = false
    ret = save
    Configuration.record_timestamps = true
    ret
  end
  def apply_changes
    self.last_changes_applied_at = Time.now
    self.daemon_reload = true
    save_without_timestamps
  end

  include CommaSeparatedArray
  comma_separated_array_field :default_prio_protos, :default_prio_helpers, :default_tcp_prio_ports, :default_udp_prio_ports

end
