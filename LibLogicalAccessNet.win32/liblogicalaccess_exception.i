/* File : liblogicalaccess_exception.i */
%module(directors="1") liblogicalaccess_exception

%include "liblogicalaccess.i"

%{
#include <memory> 
#include <logicalaccess/myexception.hpp>
#include <logicalaccess/crypto/openssl_exception.hpp>
%}

%shared_ptr(logicalaccess::Exception::exception);
%shared_ptr(logicalaccess::LibLogicalAccessException);
%shared_ptr(logicalaccess::CardException);
%shared_ptr(logicalaccess::IKSException);

%include <logicalaccess/myexception.hpp>
%include <logicalaccess/crypto/openssl_exception.hpp>