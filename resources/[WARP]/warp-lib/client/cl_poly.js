class PolyZone {
    static addBoxZone(pId, pCenter, pLength, pWidth, pOptions) {
        exports['warp-polyzone'].AddBoxZone(pId, pCenter, pLength, pWidth, pOptions);
    }

    static addCircleZone(pId, pCenter, pRadius, pOptions) {
        exports['warp-polyzone'].AddCircleZone(pId, pCenter, pRadius, pOptions);
    }
}

class PolyTarget {
    static addBoxZone(pId, pCenter, pLength, pWidth, pOptions) {
        exports['warp-polytarget'].AddBoxZone(pId, pCenter, pLength, pWidth, pOptions);
    }

    static addCircleZone(pId, pCenter, pRadius, pOptions) {
        exports['warp-polytarget'].AddCircleZone(pId, pCenter, pRadius, pOptions);
    }
}
