#include "filemanager.h"

FileManager::FileManager(ArgumentManager *argumentManager)
{
    this->argumentManager=argumentManager;
    callerDataRegionFile=NULL;
    callerDataRegionStream=NULL;
    statsFile=NULL;
    statsStream=NULL;
    slopeFile=NULL;
    slopeStream=NULL;
    profilingFile=NULL;
    profilingStream=NULL;
    inputPrvFiles=NULL;
    outputPrvFiles=NULL;
}

FileManager::~FileManager()
{
    for(StreamSet* stream:streamSets){
        delete stream;
    }
    if (callerDataRegionFile!=NULL){
        delete callerDataRegionFile;
    }
    if (callerDataRegionStream!=NULL){
        delete callerDataRegionStream;
    }
    if (statsFile!=NULL){
        delete statsFile;
    }
    if (statsStream!=NULL){
        delete statsStream;
    }
    if (slopeFile!=NULL){
        delete slopeFile;
    }
    if (slopeStream!=NULL){
        delete slopeStream;
    }
    if (profilingFile!=NULL){
        delete profilingFile;
    }
    if (profilingStream!=NULL){
        delete profilingStream;
    }
    if (inputPrvFiles!=NULL){
        delete inputPrvFiles;
    }
    if (outputPrvFiles!=NULL){
        delete outputPrvFiles;
    }
}

int FileManager::init()
{
    int error;
    if ((error=mkoutputDir())!=RETURN_OK){
        return error;
    }
    if ((error=set())!=RETURN_OK){
        return error;
    }
    return RETURN_OK;
}

int FileManager::mkoutputDir()
{
    if (!argumentManager->getUniqueFile()){
        QDir dir(argumentManager->getInput());
        if (!dir.exists()){
            qWarning().nospace()<<"Invalid input directory";
            return RETURN_ERR_INVALID_INPUT_DIR;
        }
        inputDir=dir.absolutePath();
    }else{
        QFileInfo fileInfo(argumentManager->getInput());
        if (!fileInfo.exists()){
            qWarning().nospace()<<"Invalid input file";
            return RETURN_ERR_INVALID_INPUT_FILE;
        }
        inputDir=fileInfo.absolutePath();
    }
    if (argumentManager->getOutput().isEmpty()){
        outputDir=inputDir+RRI_DIR_PATTERN;
    }else{
        outputDir=argumentManager->getOutput();
    }
    if (QDir(outputDir).exists()){
        qWarning().nospace()<<"Output directory already exists";
        return RETURN_ERR_EXISTING_OUTPUT_DIR;
    }
    if (QDir().mkdir(outputDir)){
        return RETURN_OK;
    }else{
        qWarning().nospace()<<"Unable to create output directory";
        return RETURN_ERR_INVALID_OUTPUT_DIR;
    }
}

int FileManager::set()
{
    int error=RETURN_OK;
    if (argumentManager->getUniqueFile()){
        callerDataFileNames.push_back(argumentManager->getInput());
        QFileInfo fileInfo(callerDataFileNames.last());
        QString basename=fileInfo.completeBaseName();
        QStringList iterationNameList=basename.split('.');
        QString iterationName=iterationNameList.last();
        callerDataRegions.push_back(iterationName);
        QString outputSubDir=outputDir+"/"+iterationName;
        QDir().mkdir(outputSubDir);
        streamSets.push_back(new StreamSet());
        if ((error=streamSets.last()->setOuputStreams(outputSubDir))!=RETURN_OK){
            qWarning().nospace()<<"Unable to set output streams";
            return RETURN_ERR_INVALID_OUTPUT_STREAM;
        }
        if ((error=streamSets.last()->setInputStream(callerDataFileNames.last()))!=RETURN_OK){
            qWarning().nospace()<<"Unable to set input streams";
            return RETURN_ERR_INVALID_INPUT_STREAM;
        }
    }else{     
        QDir dir(inputDir);
        dir.setNameFilters(QStringList() << CSV_FILES);
        dir.setFilter(QDir::Files);
        foreach(QFileInfo fileInfo, dir.entryInfoList())
        {
            bool error;
            QString name=fileInfo.fileName();
            QString destFile=outputDir+"/"+name;
            QFile::remove(destFile);
            error=QFile::copy(fileInfo.filePath(), destFile);
            if (!error){
                return RETURN_ERR_COPY_CSV;
            }
        }
        dir.setNameFilters(QStringList() << CALLERDATA_FILES);
        dir.setFilter(QDir::Files);
        foreach(QFileInfo fileInfo, dir.entryInfoList())
        {
            QString file=fileInfo.absoluteFilePath();
            callerDataFileNames.push_back(file);
            QString basename=fileInfo.completeBaseName();
            QStringList regionNameList=basename.split('.');
            QString regionName=regionNameList.last();
            if (argumentManager->getRegions().size()==0||(argumentManager->getRegions().size()>0&&argumentManager->getRegions().contains(regionName))){
                regions.push_back(regionName);
                QString outputSubDir=outputDir+"/"+regionName;
                QDir().mkdir(outputSubDir);
                streamSets.push_back(new StreamSet());
                if ((error=streamSets.last()->setOuputStreams(outputSubDir))!=RETURN_OK){
                    qWarning().nospace()<<"Unable to set output streams";
                    return RETURN_ERR_INVALID_OUTPUT_STREAM;
                }
                if ((error=streamSets.last()->setInputStream(file))!=RETURN_OK){
                    qWarning().nospace()<<"Unable to set input streams";
                    return RETURN_ERR_INVALID_INPUT_STREAM;
                }
            }
        }
        dir.setNameFilters(QStringList() << CALLERDATA_REGIONS_FILE);
        dir.setFilter(QDir::Files);
        if (dir.entryList().size()==0){
            qWarning().nospace()<<"No region file found";
            return RETURN_ERR_INVALID_REGION_FILE;
        }
        callerDataRegions=dir.entryList().first();
        callerDataRegionFile=new QFile(dir.path()+"/"+callerDataRegions);
        if (!callerDataRegionFile->open(QIODevice::ReadOnly | QIODevice::Text)){
           qWarning().nospace()<<"Unable to open region file";
           return RETURN_ERR_INVALID_REGION_FILE;
        }
        callerDataRegionStream=new QTextStream(callerDataRegionFile);

        dir.setNameFilters(QStringList() << STATS_FILE);
        dir.setFilter(QDir::Files);
        if (dir.entryList().size()==0){
            qWarning().nospace()<<"No stat file found";
            return RETURN_ERR_INVALID_STATS_FILE;
        }
        stats=dir.entryList().first();
        statsFile=new QFile(dir.path()+"/"+stats);
        if (!statsFile->open(QIODevice::ReadOnly | QIODevice::Text)){
           qWarning().nospace()<<"Unable to open stats file";
           return RETURN_ERR_INVALID_STATS_FILE;
        }
        statsStream=new QTextStream(statsFile);

        dir.setNameFilters(QStringList() << SLOPE_FILE);
        dir.setFilter(QDir::Files);
        if (dir.entryList().size()==0){
            qWarning().nospace()<<"No slope file found";
            return RETURN_ERR_INVALID_SLOPE_FILE;
        }
        slopes=dir.entryList().first();
        slopeFile=new QFile(dir.path()+"/"+slopes);
        if (!slopeFile->open(QIODevice::ReadOnly | QIODevice::Text)){
           qWarning().nospace()<<"Unable to open slope file";
           return RETURN_ERR_INVALID_SLOPE_FILE;
        }
        slopeStream=new QTextStream(slopeFile);

        dir.setNameFilters(QStringList() << PRV_INPUT_FILE);
        dir.setFilter(QDir::Files);
        if (dir.entryList().size()==0){
            qWarning().nospace()<<"No input trace file found";
            return RETURN_ERR_INVALID_INPUT_TRACE;
        }
        inputPrvFiles=new PrvFileManager();
        if ((error=inputPrvFiles->initStreams(dir.path()+"/"+dir.entryList().first(), QIODevice::ReadOnly | QIODevice::Text))!=RETURN_OK){
            qWarning().nospace()<<"Unable to open input trace file";
            return RETURN_ERR_INVALID_INPUT_TRACE;
        }
        QString inputPrvBaseName=inputPrvFiles->getPrv();
        QFileInfo fileInfo=QFileInfo(inputPrvBaseName);
        inputPrvBaseName=fileInfo.completeBaseName();
        QString outputPrv=outputDir+"/"+inputPrvBaseName+RRI_DIR_PATTERN+RRI_PRV_PATTERN;
        if ((error=PrvFileManager::copyTrace(inputPrvFiles->getPrv(), outputPrv))!=RETURN_OK){
            qWarning().nospace()<<"Unable to generate output trace file";
            return RETURN_ERR_COPY_TRACE;
        }
        outputPrvFiles=new PrvFileManager();
        if ((error=outputPrvFiles->initStreams(outputPrv, QIODevice::ReadWrite | QIODevice::Text | QIODevice::Append))!=RETURN_OK){
            qWarning().nospace()<<"Unable to create output trace file";
            return RETURN_ERR_INVALID_OUTPUT_TRACE;
        }

        profiling=outputDir + "/" + inputPrvBaseName + RRI_DIR_PATTERN + "." + PROFILING_FILE;
        profilingFile=new QFile(profiling);
        if (!profilingFile->open(QIODevice::ReadWrite | QIODevice::Text)){
           qWarning().nospace()<<"Unable to create profiling file";
           return RETURN_ERR_INVALID_PROFILING_FILE;
        }
        profilingStream=new QTextStream(profilingFile);
    }
    return RETURN_OK;
}

QTextStream *FileManager::getProfilingStream() const
{
    return profilingStream;
}

QTextStream *FileManager::getSlopeStream() const
{
    return slopeStream;
}

QTextStream *FileManager::getStatsStream() const
{
    return statsStream;
}

QTextStream *FileManager::getCallerDataRegionStream() const
{
    return callerDataRegionStream;
}

PrvFileManager *FileManager::getOutputPrvFiles() const
{
    return outputPrvFiles;
}

PrvFileManager *FileManager::getInputPrvFiles() const
{
    return inputPrvFiles;
}


QVector<StreamSet *> FileManager::getStreamSets() const
{
    return streamSets;
}

QString FileManager::getOutputDir() const
{
    return outputDir;
}

QString FileManager::getInputDir() const
{
    return inputDir;
}

QVector<QString> FileManager::getCallerDataFileNames() const
{
    return callerDataFileNames;
}

ArgumentManager *FileManager::getArgumentManager() const
{
    return argumentManager;
}

QVector<QString> FileManager::getRegions() const
{
    return regions;
}



