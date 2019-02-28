#include "mynewvariabletype.h"

MyNewVariableType::MyNewVariableType(QOpcUaServerNode *parent) : QOpcUaBaseDataVariable(parent)
{
	qDebug() << "MyNewVariableType C++ constructor.";
}

QOpcUaBaseDataVariable * MyNewVariableType::getMyVar()
{
	return m_myVar;
}

QOpcUaBaseObject * MyNewVariableType::getMyObj()
{
	return m_myObj;
}

MyOtherNewVariableType * MyNewVariableType::getMyOtherVar()
{
	return m_myOtherVar;
}


// ---

MyOtherNewVariableType::MyOtherNewVariableType(QOpcUaServerNode *parent) : QOpcUaBaseDataVariable(parent)
{
	qDebug() << "MyOtherNewVariableType C++ constructor.";
}

// ---

MyNewVariableSubType::MyNewVariableSubType(QOpcUaServerNode *parent) : MyNewVariableType(parent)
{

}

QOpcUaBaseObject * MyNewVariableSubType::getMyObjSub()
{
	return m_myObjSub;
}

// ---

MyNewVariableSubSubType::MyNewVariableSubSubType(QOpcUaServerNode *parent) : MyNewVariableSubType(parent)
{
	qDebug() << "MyNewVariableSubSubType C++ constructor.";
}

QOpcUaBaseObject * MyNewVariableSubSubType::getMyObjSubSub()
{
	return m_myObjSubSub;
}
