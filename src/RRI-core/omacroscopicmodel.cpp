#include "omacroscopicmodel.h"


OMacroscopicModel::OMacroscopicModel(MicroscopicModel* microscopicModel):
    MacroscopicModel(microscopicModel),lpaggreg(NULL)
{

}

OMacroscopicModel::~OMacroscopicModel()
{
    for (int i=parts.size()-1; i>=0; i--){
        delete parts[i];
    }
    delete lpaggreg;
}

void OMacroscopicModel::initializeAggregator()
{
    delete lpaggreg;
    lpaggreg=new OLPAggreg3(*(microscopicModel->getMatrix()));
}

void OMacroscopicModel::computeQualities(bool normalize)
{
    initializeAggregator();
    lpaggreg->computeQualities(normalize);
}

void OMacroscopicModel::computeBestPartitions(float threshold)
{
    ps=QVector<float>::fromStdVector(lpaggreg->getParameters(threshold));
    qualities=QVector<Quality*>::fromStdVector(lpaggreg->getQualityList());
}

void OMacroscopicModel::computeBestPartition(float parameter)
{
    vector<int>partsTemp=lpaggreg->getParts(parameter);
    parts=QVector<Part*>();
    Part* currentPart=new Part(microscopicModel->getMatrix()->size());
    currentPart->setFirstTimeSlice(0);
    int currentPartIndice=0;
    unsigned int i=0;
    for (i=0;i<partsTemp.size()-1;i++){
        if (partsTemp[i+1]!=currentPartIndice){
            currentPart->setLastTimeSlice(i);
            parts.append(currentPart);
            currentPart=new Part(microscopicModel->getMatrix()->size());
            currentPart->setFirstTimeSlice(i+1);
            currentPartIndice=partsTemp[i+1];
        }

    }
    currentPart->setLastTimeSlice(i);
    parts.append(currentPart);
}

QVector<Part*> OMacroscopicModel::getParts() const
{
    return parts;
}
