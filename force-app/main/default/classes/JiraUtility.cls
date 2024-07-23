public class JiraUtility {
    public static String getSelectedProjectAddress(List<Map<String, Map<String, String>>> projectMapList, String selectedValues) {
        for (Map<String, Map<String, String>> projectMap : projectMapList) {
            Map<String, String> nameAddressMapper = projectMap.get('NameAddressMapper');
            for (String address : nameAddressMapper.keySet()) {
                String projectName = nameAddressMapper.get(address);
                if (projectName.equals(selectedValues)) {
                    return address;
                }
            }
        }
        return null;
    }

    public static String convertSecondsToDHMS(Integer totalSeconds) {
        if(totalSeconds == NULL){
            return NULL;
        }
        Integer days = totalSeconds / (8 * 3600);
        Integer remainder = totalSeconds - (days * 8 * 3600);
        Integer hours = remainder / 3600;
        remainder = remainder - (hours * 3600);
        Integer minutes = remainder / 60;
    
        return days + ' days ' + hours + ' hours ' + minutes + ' minutes';
    }

    public static Date parseDate(String dateString) {
        if (dateString != null) {
            return Date.valueOf(dateString);
        } else {
            return null;
        }
    }

    public static String getUserByName(String name) {
        List<String> userIds = new List<String>{
        '005dM000000okdeQAA',  
        '005dM000000okdGQAQ',
        '005dM000000omOGQAY'
      };

        if (name == null) {
            Integer randomIndex = Math.floor(Math.random() * userIds.size()).intValue();
            return userIds[randomIndex];
        }
        
        List<User> userList = [SELECT Id FROM User WHERE Name = :name LIMIT 1];
        if (!userList.isEmpty()) {
            return userList[0].Id;
        } else {
            Integer randomIndex = Math.floor(Math.random() * userIds.size()).intValue();
            return userIds[randomIndex];
        }
    }
}