/*  RRI - Relevant Routine Identifier
*  Copyright (C) 2016  Damien Dosimont
*  
*  This file is part of RRI.
*  
*  RRI is free software: you can redistribute it and/or modify
*  it under the terms of the GNU General Public License as published by
*  the Free Software Foundation, either version 3 of the License, or
*  (at your option) any later version.
*  
*  This program is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*  
*  You should have received a copy of the GNU General Public License
*  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "rriobject.h"

RRIObject::RRIObject()
                     :id(-1), sample(0), tsPercentage(0),
                     tsAbsolute(0), callstackLvl(0),
                     routineId(0), routineName(""),
                     codelineId(0), fileName(""), codeline(0)
{

}

int RRIObject::getId() const
{
    return id;
}

void RRIObject::setId(int value)
{
    id = value;
}

void RRIObject::setId(QString value)
{
    setId(value.toInt());
}

int RRIObject::getSample() const
{
    return sample;
}

void RRIObject::setSample(int value)
{
    sample = value;
}

void RRIObject::setSample(QString value)
{
    setSample(value.toInt());
}

double RRIObject::getTsPercentage() const
{
    return tsPercentage;
}

void RRIObject::setTsPercentage(double value)
{
    tsPercentage = value;
}

void RRIObject::setTsPercentage(QString value)
{
    setTsPercentage(value.toDouble());
}

int RRIObject::getTsAbsolute() const
{
    return tsAbsolute;
}

void RRIObject::setTsAbsolute(int value)
{
    tsAbsolute = value;
}

void RRIObject::setTsAbsolute(QString value)
{
    setTsAbsolute(value.toInt());
}

int RRIObject::getCallstackLvl() const
{
    return callstackLvl;
}

void RRIObject::setCallstackLvl(int value)
{
    callstackLvl = value;
}

void RRIObject::setCallstackLvl(QString value)
{
    setCallstackLvl(value.toInt());
}

int RRIObject::getRoutineId() const
{
    return routineId;
}

void RRIObject::setRoutineId(int value)
{
    routineId = value;
}

void RRIObject::setRoutineId(QString value)
{
    setRoutineId(value.toInt());
}

QString RRIObject::getRoutineName() const
{
    return routineName;
}

void RRIObject::setRoutineName(QString value)
{
    routineName = value;
}

void RRIObject::setFilteredRoutineName(QString value)
{
    routineName = value;
}

void RRIObject::setFilteredFileName(QString value)
{
    fileName = value;
    fileName= fileName.split(" ").last();
    fileName = fileName.remove( QRegExp( "^\\(" ) );
}

int RRIObject::getCodelineId() const
{
    return codelineId;
}

void RRIObject::setCodelineId(int value)
{
    codelineId = value;
}

void RRIObject::setCodelineId(QString value)
{
    setCodelineId(value.toInt());
}

int RRIObject::getCodeline() const
{
    return codeline;
}

void RRIObject::setCodeline(int value)
{
    codeline = value;
}

void RRIObject::setCodeline(QString value)
{
    setCodeline(value.toInt());
}

QString RRIObject::getFileName() const
{
    return fileName;
}

void RRIObject::setFileName(const QString &value)
{
    fileName = value;
}


QString RRIObject::getRoutineIdAndCallStack()
{
    return QString::number(routineId)+":"+QString::number(callstackLvl);
}

QString RRIObject::toString()
{
    return "RRI Object: ID "+QString::number(getId())+
          ", sample "+QString::number(getSample())+
          ", timestamp: "+QString::number(getTsAbsolute())+" ("+QString::number(getTsPercentage())+")"+
          ", routine: "+getRoutineName()+
          ", routine ID: "+QString::number(getRoutineId())+
          ", callstack LVL: "+QString::number(getCallstackLvl());
}

int RRIObject::getIndex() const
{
    return index;
}

void RRIObject::setIndex(int value)
{
    index = value;
}

QTextStream& operator<<(QTextStream& out, RRIObject object)
{
    out<<&object;
    return out;
}

QTextStream& operator<<(QTextStream& out, RRIObject* object)
{
    out<<object->toString()<<endl;
    return out;
}


