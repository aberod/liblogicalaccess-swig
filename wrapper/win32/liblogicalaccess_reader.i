/* File : liblogicalaccess_reader.i */
%module(directors="1") liblogicalaccess_reader

%include "liblogicalaccess.i"

%import "liblogicalaccess_data.i"
%import "liblogicalaccess_card.i"

%typemap(csimports) SWIGTYPE
%{
using LibLogicalAccess;
using LibLogicalAccess.Card;
%}

%shared_ptr(logicalaccess::ReaderConfiguration);
%shared_ptr(logicalaccess::ReaderProvider);
%shared_ptr(logicalaccess::ReaderUnit);
%shared_ptr(logicalaccess::ReaderUnitConfiguration);
%shared_ptr(logicalaccess::LCDDisplay);
%shared_ptr(logicalaccess::LEDBuzzerDisplay);
%shared_ptr(logicalaccess::ReaderService);

typedef std::shared_ptr<logicalaccess::ReaderProvider> ReaderProviderPtr;
typedef std::shared_ptr<logicalaccess::ReaderUnit> ReaderUnitPtr;
typedef std::shared_ptr<logicalaccess::ReaderService> ReaderServicePtr;
typedef std::shared_ptr<logicalaccess::ReaderService> ReaderServicePtr;

%{
#include <logicalaccess/readerproviders/readerconfiguration.hpp>
#include <logicalaccess/readerproviders/readerprovider.hpp>
#include <logicalaccess/readerproviders/readerunitconfiguration.hpp>
#include <logicalaccess/readerproviders/lcddisplay.hpp>
#include <logicalaccess/readerproviders/ledbuzzerdisplay.hpp>
#include <logicalaccess/services/reader_service.hpp>

using namespace logicalaccess;

%}

/* original header files */
%include <logicalaccess/readerproviders/readerunitconfiguration.hpp>
%include <logicalaccess/readerproviders/lcddisplay.hpp>
%include <logicalaccess/readerproviders/ledbuzzerdisplay.hpp>
%include <logicalaccess/readerproviders/readerunit.hpp>
%include <logicalaccess/readerproviders/readerprovider.hpp>
%include <logicalaccess/readerproviders/readerconfiguration.hpp>
%include <logicalaccess/services/reader_service.hpp>

%template(ReaderUnitCollection) std::vector<std::shared_ptr<logicalaccess::ReaderUnit> >;