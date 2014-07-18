#!/usr/bin/env python
# -*- coding: utf-8 -*-

import gi.repository.Gio

settings = gi.repository.Gio.Settings.new('org.gnome.Vino')

def set_value(key, value):
    """
    For a given key sets a value
    """
    if settings[key] == value:
        return
    settings[key] = value
    return str(key)+str(value)


def get_value(key):
    """
    For a given key returns current value from vino's gsettings
    """
    return settings[key]


if __name__ == '__main__':
    for key in settings.keys():
        print('{} : {}'. format(key, settings[key]))
