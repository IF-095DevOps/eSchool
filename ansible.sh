#!/bin/bash
if (( $(ansible --version) = command not found ))
then
echo "Service is running!!!"
else
echo "Service is stopped!!!"
fi