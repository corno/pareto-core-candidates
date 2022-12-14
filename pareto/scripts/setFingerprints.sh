#!/usr/bin/env bash

scriptDir=`realpath $(dirname "$0")`
rootDir="$scriptDir/../.."

pubDir="$rootDir/pub"

#I want to have a fingerprint of the content of an npm package to be able to see if the local data is
#identical to what was already published. If that is the case, there is nothing to publish
#the version should not be part of that
#if I publish the exact same package under 2 version numbers, the fingerprint should be the same

if [ -d "$pubDir" ]
then
    pushd "$pubDir" > /dev/null
    
    #first take care of the interface fingerprint
    interfaceDir="./src/interface"
    if [ -d "$interfaceDir" ]
    then
        npm pkg set interface-fingerprint=`tar -cf - $interfaceDir | shasum | cut -c1-40`
    else
        npm pkg delete interface-fingerprint #delete if it was there
    fi

    #now take care of the content fingerp

    #get the version property from the package.json file
    #then trim the quotes before and after
    version=$(npm pkg get version | cut -c2- | rev | cut -c2- |rev) 

    #the version property is mandatory for the 'npm pack' command, so I temporarily set it to '0.0.0'
    npm pkg set version=0.0.0
    npm pkg delete content-fingerprint

    #create a package, but don't store it (--dry-run), let the summary output be json
    #create a shasum of that and then trim to the first 40 characters of that shasum (the rest is filename info, which in this case is: ' -')
    contentfingerprint=$(npm pack --dry-run --json | shasum | cut -c1-40)

    npm pkg set version="$version" #restore version
    npm pkg set content-fingerprint="$contentfingerprint" #restore version

    popd
fi