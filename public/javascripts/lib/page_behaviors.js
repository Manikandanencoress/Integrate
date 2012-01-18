window.BehaviorMap = {};

window.Behaviors = {
    addBehaviors : function() {
        for (var behaviorSelector in BehaviorMap)
            if (jQuery(behaviorSelector).length > 0)
                BehaviorMap[behaviorSelector]();
    }
};