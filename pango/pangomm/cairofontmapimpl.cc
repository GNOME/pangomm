/* Copyright (C) 2021 The gtkmm Development Team
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <pangomm/cairofontmapimpl.h>
#include <utility> // std::move()

namespace Pango
{
CairoFontMapImpl::CairoFontMapImpl(PangoFontMap* castitem)
: Glib::ObjectBase(nullptr), FontMap(castitem)
{}

CairoFontMapImpl::CairoFontMapImpl(CairoFontMapImpl&& src) noexcept
: CairoFontMap(std::move(src)),
  FontMap(std::move(src))
{}

CairoFontMapImpl& CairoFontMapImpl::operator=(CairoFontMapImpl&& src) noexcept
{
  CairoFontMap::operator=(std::move(src));
  FontMap::operator=(std::move(src));
  return *this;
}

CairoFontMapImpl::~CairoFontMapImpl() noexcept
{}

} // namespace Pango
