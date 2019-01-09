/**
 * Created by BRITENET on 16.12.2018.
 */

public with sharing class Hospital_HospitalHierarchyController {
    //Declare variables
    public String currentId;
    public List<ObjectStructureMap> asm ;
    public Map<String, ObjectStructureMap> masm;
    public List<Integer> maxLevel;

    public Hospital_HospitalHierarchyController() {
        this.asm = new List<ObjectStructureMap>{
        };
        this.masm = new Map<String, ObjectStructureMap>{
        };
        this.maxLevel = new List<Integer>{
        };
    }

    public void setCurrentId(String cid) {
        currentId = cid;
    }

    public List<ObjectStructureMap> getObjectStructure() {
        asm.clear();
        if (currentId == null) {
            currentId = System.currentPageReference().getParameters().get('id');
        }

        System.assertNotEquals(currentId, null, 'sObject ID must be provided');
        asm = formatObjectStructure(CurrentId);

        return asm;
    }

    public ObjectStructureMap[] formatObjectStructure(String currentId) {

        List<ObjectStructureMap> asm = new List<ObjectStructureMap>{
        };
        masm.clear();

        //Change below
        List<Hospital__c> al = new List<Hospital__c>{
        };
        List<ID> currentParent = new List<ID>{
        };
        Map<ID, String> nodeList = new Map<ID, String>{
        };
        List<String> nodeSortList = new List<String>{
        };
        List<Boolean> levelFlag = new List<Boolean>{
        };
        List<Boolean> closeFlag = new List<Boolean>{
        };
        String nodeId = '0';
        String nodeType = 'child';
        Integer count = 0;
        Integer level = 0;
        Boolean endOfStructure = false;

        //Find highest level obejct in the structure
        currentParent.add(GetTopElement(currentId));

        //Loop though all children
        while (!endOfStructure) {

            if (level == 0) {
                //Change below
                al = [SELECT a.Parent_Hospital__c, a.Name, a.Id FROM Hospital__c a WHERE a.id IN :CurrentParent ORDER BY a.Name];
            } else {
                //Change below
                al = [SELECT a.Parent_Hospital__c, a.Name, a.Id FROM Hospital__c a WHERE a.Parent_Hospital__c IN :CurrentParent ORDER BY a.Name];
            }

            if (al.size() == 0) {
                endOfStructure = true;
            } else {
                currentParent.clear();
                for (Integer i = 0; i < al.size(); i++) {
                    //Change below
                    Hospital__c a = al[i];
                    nodeId = (level > 0) ? NodeList.get(a.Parent_Hospital__c) + '.' + String.valueOf(i) : String.valueOf(i);
                    masm.put(NodeID, new ObjectStructureMap(nodeID, levelFlag, closeFlag, nodeType, false, false, a));
                    currentParent.add(a.id);
                    nodeList.put(a.id, nodeId);
                    nodeSortList.add(nodeId);
                }

                maxLevel.add(level);
                level++;
            }
        }

        //Account structure must now be formatted
        NodeSortList.sort();
        for (Integer i = 0; i < NodeSortList.size(); i++) {
            List<String> pnl = new List<String>{
            };
            List<String> cnl = new List<String>{
            };
            List<String> nnl = new List<String>{
            };

            if (i > 0) {
                String pn = NodeSortList[i - 1];
                pnl = pn.split('\\.', -1);
            }

            String cn = NodeSortList[i];
            cnl = cn.split('\\.', -1);

            if (i < NodeSortList.size() - 1) {
                String nn = NodeSortList[i + 1];
                nnl = nn.split('\\.', -1);
            }

            ObjectStructureMap tasm = masm.get(cn);
            if (cnl.size() < nnl.size()) {
                //Parent
                tasm.nodeType = (isLastNode(cnl)) ? 'parent_end' : 'parent';
            } else if (cnl.size() > nnl.size()) {
                tasm.nodeType = 'child_end';
                tasm.closeFlag = setcloseFlag(cnl, nnl, tasm.nodeType);
            } else {
                tasm.nodeType = 'child';
            }

            tasm.levelFlag = setlevelFlag(cnl, tasm.nodeType);

            //Change below
            if (tasm.hospital.id == currentId) {
                tasm.currentNode = true;
            }
            asm.add(tasm);
        }

        asm[0].nodeType = 'start';
        asm[asm.size() - 1].nodeType = 'end';

        return asm;
    }
    
    public List<Boolean> setLevelFlag(List<String> nodeElements, String nodeType) {

        List<Boolean> flagList = new List<Boolean>{
        };
        String searchNode = '';
        String workNode = '';
        Integer cn = 0;

        for (Integer i = 0; i < nodeElements.size() - 1; i++) {
            cn = Integer.valueOf(nodeElements[i]);
            cn++;
            searchNode = workNode + String.valueOf(cn);
            workNode = workNode + nodeElements[i] + '.';
            if (masm.containsKey(searchNode)) {
                flagList.add(true);
            } else {
                flagList.add(false);
            }
        }

        return flagList;
    }

    public List<Boolean> setCloseFlag(List<String> cnl, List<String> nnl, String nodeType) {

        List<Boolean> flagList = new List<Boolean>{
        };
        String searchNode = '';
        String workNode = '';
        Integer cn = 0;

        for (Integer i = nnl.size(); i < cnl.size(); i++) {
            flagList.add(true);
        }

        return flagList;
    }

    public Boolean isLastNode(List<String> nodeElements) {

        String searchNode = '';
        Integer cn = 0;

        for (Integer i = 0; i < nodeElements.size(); i++) {
            if (i == nodeElements.size() - 1) {
                cn = Integer.valueOf(nodeElements[i]);
                cn++;
                searchNode = searchNode + String.valueOf(cn);
            } else {
                searchNode = searchNode + nodeElements[i] + '.';
            }
        }
        if (masm.containsKey(searchNode)) {
            return false;
        } else {
            return true;
        }
    }

    public String GetTopElement(String objId) {

        Boolean top = false;
        while (!top) {
            //Change below
            Hospital__c a = [Select a.Id, a.Parent_Hospital__c From Hospital__c a where a.Id = :objId limit 1];

            if (a.Parent_Hospital__c != null) {
                objId = a.Parent_Hospital__c;
            } else {
                top = true;
            }
        }
        return objId ;
    }

    public with sharing class ObjectStructureMap {

        public String nodeId;
        public Boolean[] levelFlag = new Boolean[]{
        };
        public Boolean[] closeFlag = new Boolean[]{
        };
        public String nodeType;
        public Boolean currentNode;

        public Hospital__c hospital;

        public String getNodeId() {
            return nodeId;
        }
        public Boolean[] getlevelFlag() {
            return levelFlag;
        }
        public Boolean[] getcloseFlag() {
            return closeFlag;
        }
        public String getnodeType() {
            return nodeType;
        }
        public Boolean getcurrentNode() {
            return currentNode;
        }

        public Hospital__c getHospital() {
            return hospital;
        }

        public void setnodeId(String n) {
            this.nodeId = n;
        }
        public void setlevelFlag(Boolean l) {
            this.levelFlag.add(l);
        }
        public void setlcloseFlag(Boolean l) {
            this.closeFlag.add(l);
        }
        public void setnodeType(String nt) {
            this.nodeType = nt;
        }
        public void setcurrentNode(Boolean cn) {
            this.currentNode = cn;
        }

        public void setHospital(Hospital__c a) {
            this.hospital = a;
        }

        public ObjectStructureMap(String nodeId, Boolean[] levelFlag, Boolean[] closeFlag, String nodeType, Boolean lastNode, Boolean currentNode, Hospital__c a) {

            this.nodeId = nodeId;
            this.levelFlag = levelFlag;
            this.closeFlag = closeFlag;
            this.nodeType = nodeType;
            this.currentNode = currentNode;

            //Change this to your sObject
            this.hospital = a;
        }
    }
}