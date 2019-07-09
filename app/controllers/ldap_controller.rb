require 'net/ldap'
class LdapController < ApplicationController

    def connect
        ldap = Net::LDAP.new(
            host: '34.76.121.152',
            port: 389,
            auth: {
                method: :simple,
                dn: "cn=admin,dc=arqsoft,dc=unal,dc=edu,dc=co",
                password: "unriskunal"
            }
        )
        return ldap.bind
    end

    

    def create
        email = params[:email]
        password = params[:password]
        email = email[/\A\w+/].downcase
        if connect()
            ldap = Net::LDAP.new(
                host: '34.76.121.152',

                port: 389,
                auth: {
                    method: :simple,
                    dn: "cn=" + email + "@unal.edu.co, ou=unrisk,dc=arqsoft,dc=unal,dc=edu,dc=co",
                    password: password
                }
            )
            if ldap.bind
                query = "select * from users where email LIKE '" + email + "@unal.edu.co'"
                results = ActiveRecord::Base.connection.exec_query(query)
                if results.present?
                    @newAuth = ObjAuth.new(email, password, "1")
                    puts("Autenticación satisfactoria.")
                    render json: @newAuth
                else
                    puts("Autenticación no satisfactoria, el usuario no se encuentra registrado en la base de datos.")
                    @newAuth = ObjAuth.new(email, password, "0")
                    render json: @newAuth
                end
            else
                puts("Autenticación no satisfactoria, el usuario no se encuentra registrado en el LDAP.")
                @newAuth = ObjAuth.new(email, password, "2")
                render json: @newAuth
            end
        end
    end
end

class ObjAuth
    def initialize(email, password, answer)
        @email = email
        @password = password
        @answer = answer
    end
end
