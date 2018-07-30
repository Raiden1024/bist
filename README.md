# Bist
Batch ImapSync Tool in Ruby language

## Synopsis

"Bist" is a small code written in Ruby to execute large mails migrations with Imapsync tool. 

Bist use a csv file for usernames and passwords and you can launch migration by step (ex: by slice of 10 users or all users, depending on your server ressources & performances).

## Requirements

* Ruby language (version: 2.1 minimum, tested with 2.5.1)
* imapsync tool: https://imapsync.lamiral.info/ 
(available on default repository in most Linux distributions)

## Usage

ruby bist.rb <csv_file.sv>

the csv file must respect the format: username;password for columns

The separator can be choosen by user at program execution.
